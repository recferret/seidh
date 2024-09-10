import {
  Body,
  CanActivate,
  Controller,
  ExecutionContext,
  Get,
  Injectable,
  Post,
  Session,
  UseGuards,
} from '@nestjs/common';
import { GatewayService } from './gateway.service';
import { AuthenticateRequestDTO } from './dto/authenticate.dto';
import { BuyBoostRequestDTO } from './dto/boost.buy.dto';
import { AuthGuard } from './guards/guard.auth';
import { Observable } from 'rxjs';
import { GameType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';

@Injectable()
class ProductionGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();
    if (
      process.env.NODE_ENV == 'production' &&
      !request.body.hasOwnProperty('telegramInitData')
    ) {
      return false;
    }
    return true;
  }
}

export interface IUserSession {
  userId: string;
}

@Controller()
export class GatewayController {
  constructor(private readonly gatewayService: GatewayService) {}

  @Post('authenticate')
  @UseGuards(ProductionGuard)
  authenticate(@Body() authenticateRequest: AuthenticateRequestDTO) {
    return this.gatewayService.authenticate(authenticateRequest);
  }

  @Get('user')
  @UseGuards(AuthGuard)
  getUser(@Session() session: IUserSession) {
    return this.gatewayService.getUser(session.userId);
  }

  @Post('findGame')
  @UseGuards(AuthGuard)
  findGame(
    @Session() session: IUserSession,
    @Body() body: { gameType: GameType },
  ) {
    return this.gatewayService.findGame(session.userId, body.gameType);
  }

  @Get('boosts')
  @UseGuards(AuthGuard)
  getBoosts(@Session() session: IUserSession) {
    return this.gatewayService.getBoosts(session.userId);
  }

  @Post('boosts')
  @UseGuards(AuthGuard)
  buyBoost(
    @Body() buyBoostRequest: BuyBoostRequestDTO,
    @Session() session: IUserSession,
  ) {
    return this.gatewayService.buyBoost(
      session.userId,
      buyBoostRequest.boostId,
    );
  }

  @Get('friends')
  @UseGuards(AuthGuard)
  getFriends(@Session() session: IUserSession) {
    return this.gatewayService.getFriends(session.userId);
  }
}
