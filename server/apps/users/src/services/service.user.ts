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
import { SeidhCommonBoostConstants } from '@app/seidh-common/seidh-common.boost-constants';
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

        coins: user.coins,
        teeth: user.teeth,

        characters: user.characters.map((c: any) => {
          const statsMultiplier = SeidhCommonBoostConstants.GetStatsMultiplierByLevel(this.getUserStatsLevel(user.boostsOwned));

          const character: CharacterBody = {
            id: c.id,
            type: c.type,
            active: c.active,
            levelCurrent: c.levelCurrent,
            levelMax: c.levelMax,
            expCurrent: c.expCurrent,
            expTillNewLevel: c.expTillNewLevel,
            health: c.health * statsMultiplier,
            entityShape: {
              width: c.entityShape.width,
              height: c.entityShape.height,
              rectOffsetX: c.entityShape.rectOffsetX,
              rectOffsetY: c.entityShape.rectOffsetY,
              radius: c.entityShape.radius,
            },
            movement: {
              runSpeed: c.movement.runSpeed,
              speedFactor: c.movement.speedFactor,
              inputDelay: c.movement.inputDelay,
            },
            actionMain: {
              damage: c.actionMain.damage,
              inputDelay: c.actionMain.inputDelay,
              meleeStruct: {
                aoe: c.actionMain.meleeStruct.aoe,
                shape: {
                  width: c.actionMain.meleeStruct.shape.width,
                  height: c.actionMain.meleeStruct.shape.height,
                  rectOffsetX: c.actionMain.meleeStruct.shape.rectOffsetX,
                  rectOffsetY: c.actionMain.meleeStruct.shape.rectOffsetY,
                },
              },
            },
          };
          return character;
        }),
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
      const tokensToAdd = message.userGainings.tokens;
      const expToAdd = message.userGainings.kills;

      // if (user.hasCoinBoost1) {
      //   tokensToAdd *= 2;
      // } else if (user.hasCoinBoost2) {
      //   tokensToAdd *= 3;
      // }

      // if (user.hasExpBoost1) {
      //   expToAdd *= 1.5;
      // } else if (user.hasExpBoost2) {
      //   expToAdd *= 2;
      // }

      user.coins += tokensToAdd;
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

  private getUserExpLevel(boostsOwned: string[]) {
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_EXP_3_ID))
			return 3;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_EXP_2_ID))
			return 2;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_EXP_1_ID))
			return 1;
		return 0;
	}

	private getUserWealthLevel(boostsOwned: string[]) {
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_WEALTH_3_ID))
			return 3;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_WEALTH_2_ID))
			return 2;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_WEALTH_1_ID))
			return 1;
		return 0;
	}

	private getUserAttackLevel(boostsOwned: string[]) {
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_ATTACK_3_ID))
			return 3;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_ATTACK_2_ID))
			return 2;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_ATTACK_1_ID))
			return 1;
		return 0;
	}

	private getUserMonstersLevel(boostsOwned: string[]) {
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_MONSTERS_3_ID))
			return 3;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_MONSTERS_2_ID))
			return 2;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_MONSTERS_1_ID))
			return 1;
		return 0;
	}

	private getUserItemsLevel(boostsOwned: string[]) {
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_ITEMS_DROP_3_ID))
			return 3;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_ITEMS_DROP_2_ID))
			return 2;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_ITEMS_DROP_1_ID))
			return 1;
		return 0;
	}

	private getUserStatsLevel(boostsOwned: string[]) {
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_STATS_3_ID))
			return 3;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_STATS_2_ID))
			return 2;
		if (boostsOwned.includes(SeidhCommonBoostConstants.BOOST_STATS_1_ID))
			return 1;
		return 0;
	}
}
