import { ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';

import { CanActivate, ExecutionContext, Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ClientProxy } from '@nestjs/microservices';

import { firstValueFrom } from 'rxjs';

import { IUserSession } from '../controllers/interfaces';

import {
  UsersServiceCheckTokenPattern,
  UsersServiceCheckTokenRequest,
  UsersServiceCheckTokenResponse,
} from '@lib/seidh-common/dto/users/users.check-token.msg';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    @Inject(ServiceName.Users) private usersService: ClientProxy,
  ) {}

  async canActivate(context: ExecutionContext) {
    try {
      // Try to verify token
      const request = context.switchToHttp().getRequest();
      const authToken = request.headers.authorization.split(' ')[1];
      const decodedToken = await this.jwtService.verifyAsync(authToken);

      // TODO RMK, no need to go to users  here
      // Check if token was refreshed
      const checkTokenRequest: UsersServiceCheckTokenRequest = {
        authToken,
      };
      const checkTokenResponse: UsersServiceCheckTokenResponse = await firstValueFrom(
        this.usersService.send(UsersServiceCheckTokenPattern, checkTokenRequest),
      );
      if (!checkTokenResponse.success) {
        throw new UnauthorizedException();
      }

      // Save userId to session
      request.session = {
        userId: decodedToken.userId,
      } as IUserSession;
    } catch (e) {
      throw new UnauthorizedException();
    }
    return true;
  }
}
