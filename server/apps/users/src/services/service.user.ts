import { SeidhCommonBroadcasts, ServiceName } from '@app/seidh-common';
import {
  UsersGetUserServiceRequest,
  UsersGetUserServiceResponse,
  UserBody,
  CharacterBody,
} from '@app/seidh-common/dto/users/users.get.user.msg';
import { UsersUpdateGainingsServiceMessage } from '@app/seidh-common/dto/users/users.update.gainings';
import { GameGainingTransaction } from '@app/seidh-common/schemas/game/schema.game-gaining.transaction';
import { User } from '@app/seidh-common/schemas/user/schema.user';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class ServiceUser {
  private readonly seidhCommonBroadcasts: SeidhCommonBroadcasts;

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(GameGainingTransaction.name)
    private gameGainingTransactionModel: Model<GameGainingTransaction>,
    @Inject(ServiceName.WsGateway) wsGatewayService: ClientProxy,
  ) {
    this.seidhCommonBroadcasts = new SeidhCommonBroadcasts(
      userModel,
      wsGatewayService,
    );
  }

  async getUser(request: UsersGetUserServiceRequest) {
    const response: UsersGetUserServiceResponse = {
      success: false,
    };

    try {
      const user = await this.userModel
        .findById(request.userId)
        .populate(['characters']);

      const userBody: UserBody = {
        userId: user.id,

        telegramName: user.telegramName,
        telegramPremium: user.telegramPremium,

        virtualTokenBalance: user.virtualTokenBalance,

        characters: user.characters.map((c: any) => {
          const character: CharacterBody = {
            id: c.id,
            type: c.type,
            active: c.active,
            levelCurrent: c.levelCurrent,
            levelMax: c.levelMax,
            expCurrent: c.expCurrent,
            expTillNewLevel: c.expTillNewLevel,
            health: c.health,
            movement: c.movement,
            actionMain: c.actionMain,
          };
          return character;
        }),

        hasExpBoost1: user.hasExpBoost1,
        hasExpBoost2: user.hasExpBoost2,
        hasPotionDropBoost1: user.hasPotionDropBoost1,
        hasPotionDropBoost2: user.hasPotionDropBoost2,
        hasMaxPotionBoost1: user.hasMaxPotionBoost1,
        hasMaxPotionBoost2: user.hasMaxPotionBoost2,
        hasMaxPotionBoost3: user.hasMaxPotionBoost3,
      };

      response.user = userBody;
      response.success = true;
    } catch (e) {
      Logger.error(e);
    }

    return response;
  }

  async updateGainings(message: UsersUpdateGainingsServiceMessage) {
    const user = await this.userModel.findById(message.userGainings.userId);
    if (user) {
      let tokensToAdd = message.userGainings.tokens;
      let expToAdd = message.userGainings.kills;

      if (user.hasCoinBoost1) {
        tokensToAdd *= 2;
      } else if (user.hasCoinBoost2) {
        tokensToAdd *= 3;
      }

      if (user.hasExpBoost1) {
        expToAdd *= 1.5;
      } else if (user.hasExpBoost2) {
        expToAdd *= 2;
      }

      user.virtualTokenBalance += tokensToAdd;
      user.kills += message.userGainings.kills;

      await user.save();
      await this.gameGainingTransactionModel.create({
        user,
        gameId: message.userGainings.gameId,
        exp: expToAdd,
        kills: message.userGainings.kills,
        tokens: tokensToAdd,
      });
      await this.seidhCommonBroadcasts.notifyBalanceUpdate(user.id);
    } else {
      Logger.error(
        `updateGainings. user ${message.userGainings.userId} not found`,
      );
    }
  }
}
