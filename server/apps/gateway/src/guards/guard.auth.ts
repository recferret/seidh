import { Injectable, CanActivate, ExecutionContext, UnauthorizedException, Inject } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '@app/seidh-common';
import { UsersCheckTokenMessageRequest, UsersCheckTokenMessageResponse, UsersCheckTokenPattern } from '@app/seidh-common/dto/users/users.check.token.msg';
import { firstValueFrom } from 'rxjs';
import { IUserSession } from '../gateway.controller';

@Injectable()
export class AuthGuard implements CanActivate {

    constructor(
        private readonly jwtService: JwtService,
        @Inject(ServiceName.Users) private usersService: ClientProxy
    ) {}

    async canActivate(context: ExecutionContext) {
        try {
            // Try to verify token
            const request = context.switchToHttp().getRequest();
            const authToken = request.headers.authorization.split(' ')[1];
            const decodedToken = await this.jwtService.verifyAsync(authToken);

            // Check if token was refreshed
            const checkTokenRequest: UsersCheckTokenMessageRequest = {
                authToken
            };
            const checkTokenResponse: UsersCheckTokenMessageResponse = await firstValueFrom(this.usersService.send(UsersCheckTokenPattern, checkTokenRequest));
            if (!checkTokenResponse.success) {
                throw new UnauthorizedException();
            }

            // Save userId to session
            request.session = {
                userId: decodedToken.userId
            } as IUserSession;
        } catch (e) {
            throw new UnauthorizedException();
        }
        return true;
    }
}