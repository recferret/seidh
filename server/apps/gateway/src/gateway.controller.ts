import { Body, CanActivate, Controller, ExecutionContext, Get, Injectable, Post, Session, UseGuards } from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { AuthenticateRequest } from './dto/authenticate.dto';
import { AuthGuard } from './guards/guard.auth';
import { Observable } from 'rxjs';

@Injectable()
class ProductionGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();
    if (process.env.NODE_ENV == 'production' && !request.body.hasOwnProperty('telegramInitData')) {
      return false
    }
    return true;
  }
}

export interface IUserSession {
  userId: string;
}

@Controller()
export class GatewayController {

  constructor(
    private readonly gatewayService: GatewayService
  ) {
  }

  @Post('authenticate')
  @UseGuards(ProductionGuard)
  authenticate(
    @Body() authenticateRequest: AuthenticateRequest
  ) {
    return this.gatewayService.authenticate(authenticateRequest);
  }

  @Post('findGame')
  @UseGuards(AuthGuard)
  findGame(
    @Session() session: IUserSession,
  ) {
    return this.gatewayService.findGame(session.userId);
  }

  @Get('boosts')
  @UseGuards(AuthGuard)
  getBoosts(@Session() session: IUserSession) {
    console.log(session);
  }

  @Post('boosts')
  @UseGuards(AuthGuard)
  buyBoost() {

  }

  @Get('friends')
  @UseGuards(AuthGuard)
  getFriends(@Session() session: IUserSession,)  {
    return this.gatewayService.getFriends(session.userId);
  }

}
