import { UserBalanceTransaction } from '@lib/seidh-common/schemas/user/schema.balance.transaction';
import { User } from '@lib/seidh-common/schemas/user/schema.user';
import { SeidhCommonBroadcasts } from '@lib/seidh-common/seidh-common.broadcasts';
import { ServiceName } from '@lib/seidh-common/seidh-common.internal-protocol';
import { Model } from 'mongoose';

import { Inject, Injectable, Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { InjectModel } from '@nestjs/mongoose';

import { SeidhCommonBoostsUtils } from '@lib/seidh-common/seidh-common.boosts-utils';

import {
  CharacterBody,
  UserBody,
  UsersServiceGetUserRequest,
  UsersServiceGetUserResponse,
} from '@lib/seidh-common/dto/users/users.get-user.msg';
import {
  UsersServiceUpdateBalanceRequest,
  UsersServiceUpdateBalanceResponse,
} from '@lib/seidh-common/dto/users/users.update-balance.msg';
import {
  UsersServiceUpdateKillsRequest,
  UsersServiceUpdateKillsResponse,
} from '@lib/seidh-common/dto/users/users.update-kills.msg';

import { BalanceOperationType } from '@lib/seidh-common/types/types.user';

@Injectable()
export class ServiceUser {
  private readonly seidhCommonBroadcasts: SeidhCommonBroadcasts;

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(UserBalanceTransaction.name)
    private UserBalanceTransactionModel: Model<UserBalanceTransaction>,
    @Inject(ServiceName.WsGateway) wsGatewayService: ClientProxy,
  ) {
    this.seidhCommonBroadcasts = new SeidhCommonBroadcasts(userModel, wsGatewayService);
  }

  async getUser(request: UsersServiceGetUserRequest) {
    const response: UsersServiceGetUserResponse = {
      success: false,
    };

    try {
      const user = await this.userModel.findById(request.userId).populate(['characters']);

      const userBody: UserBody = {
        userId: user.id,

        userName: user.userName,
        telegramPremium: user.tgPremium,

        coins: user.coins,
        teeth: user.teeth,

        characters: user.characters.map((c: any) => {
          const character: CharacterBody = {
            id: c.id,
            type: c.type,
            active: c.active,
            levelCurrent: c.levelCurrent,
            levelMax: c.levelMax,
            expCurrent: c.expCurrent,
            expTillNextLevel: c.expTillNextLevel,
            health: c.health,
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
              actionType: c.actionMain.actionType,
              animDurationMs: 100,
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

          // Apply boosts
          const wealthLevel = SeidhCommonBoostsUtils.GetUserWealthLevel(user.boostsOwned);
          const statsLevel = SeidhCommonBoostsUtils.GetUserStatsLevel(user.boostsOwned);

          const wealthRadiusMultiplier = SeidhCommonBoostsUtils.GetWealthRadiusMultiplierByLevel(wealthLevel);
          const statsMultiplier = SeidhCommonBoostsUtils.GetStatsMultiplierByLevel(statsLevel);

          character.entityShape.radius *= wealthRadiusMultiplier;

          character.health *= statsMultiplier;
          character.movement.runSpeed *= statsMultiplier;
          character.actionMain.damage *= statsMultiplier;

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

  async updateKills(request: UsersServiceUpdateKillsRequest) {
    const response: UsersServiceUpdateKillsResponse = {
      success: false,
    };

    try {
      const user = await this.userModel.findById(request.userId);
      if (user) {
        user.monsterKills += request.zombiesKilled;
        await user.save();
        response.success = true;
      } else {
        Logger.error(`updateKills. user ${request.userId} not found`);
      }
    } catch (error) {
      Logger.error(
        {
          message: 'updateKills error',
          request,
        },
        error,
      );
    }

    return response;
  }

  async updateBalance(request: UsersServiceUpdateBalanceRequest) {
    const response: UsersServiceUpdateBalanceResponse = {
      success: false,
    };

    try {
      if (!request.coins && !request.teeth) {
        return response;
      }

      const user = await this.userModel.findById(request.userId);
      if (user) {
        const wealthLevel = SeidhCommonBoostsUtils.GetUserWealthLevel(user.boostsOwned);

        if (request.coins) {
          if (request.operation == BalanceOperationType.ADD) {
            const wealthCoinsMultiplier = SeidhCommonBoostsUtils.GetWealthCoinsMultiplierByLevel(wealthLevel);
            user.coins += request.coins * wealthCoinsMultiplier;
          } else {
            if (user.coins - request.coins >= 0) {
              user.coins -= request.coins;
            } else {
              return response;
            }
          }
        }

        if (request.teeth) {
          if (request.operation == BalanceOperationType.ADD) {
            user.teeth += request.teeth;
          } else {
            if (user.teeth - request.teeth >= 0) {
              user.teeth -= request.teeth;
            } else {
              return response;
            }
          }
        }

        await user.save();
        await this.UserBalanceTransactionModel.create({
          user,
          balanceUpdateReason: request.reason,
          balanceOperationType: request.operation,
          currentWealthLevel: wealthLevel,
          coins: request.coins,
          teeth: request.teeth,
        });

        await this.seidhCommonBroadcasts.notifyBalanceUpdate(user.id);

        response.success = true;
      } else {
        Logger.error(`updateBalance. user ${request.userId} not found`);
      }
    } catch (error) {
      Logger.error(
        {
          message: 'updateBalance error',
          request,
        },
        error,
      );
    }

    return response;
  }
}
