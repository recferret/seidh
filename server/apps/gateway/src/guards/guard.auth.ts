import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthGuard implements CanActivate {

    constructor(private readonly jwtService: JwtService) {}

    async canActivate(context: ExecutionContext) {
        try {
            const request = context.switchToHttp().getRequest();
            await this.jwtService.verifyAsync(request.headers.authorization.split(' ')[1])
        } catch (e) {
            throw new UnauthorizedException();
        }

        return true;
    }
}