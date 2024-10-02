import { ClientProxy } from '@nestjs/microservices';
import { Model } from 'mongoose';
import {
  WsGatewayUserBalanceMsg,
  WsGatewayUserBalancePattern,
} from './dto/ws-gateway/ws-gateway.user.balance.msg';
import { User } from './schemas/user/schema.user';

export class SeidhCommonBroadcasts {
  constructor(
    private userModel: Model<User>,
    private wsGatewayService: ClientProxy,
  ) {}

  public async notifyBalanceUpdate(userId: string) {
    const user = await this.userModel.findById(userId);
    if (user) {
      const message: WsGatewayUserBalanceMsg = {
        targetUserId: userId,
        coins: user.coins,
        teeth: user.teeth,
      };
      this.wsGatewayService.emit(WsGatewayUserBalancePattern, message);
    }
  }
}
