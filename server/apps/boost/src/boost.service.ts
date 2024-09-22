import { SeidhCommonBroadcasts, ServiceName } from '@app/seidh-common';
import {
  BoostsBuyBoostServiceRequest,
  BoostsBuyBoostServiceResponse,
} from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';
import {
  BoostBody,
  BoostsGetServiceRequest,
  BoostsGetServiceResponse,
} from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import {
  Boost,
  BoostDocument,
} from '@app/seidh-common/schemas/boost/schema.boost';
import { BoostTransaction } from '@app/seidh-common/schemas/boost/schema.boost.transaction';
import { User } from '@app/seidh-common/schemas/user/schema.user';
import { Inject, Injectable, OnModuleInit } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class BoostService implements OnModuleInit {
  private readonly boosts: Array<BoostDocument> = [];

  private static readonly BOOST_EXP_BOOST_1_NAME = 'Exp 1';
  private static readonly BOOST_EXP_BOOST_1_DESCRIPTION = '+50% exp';
  private static readonly BOOST_EXP_BOOST_2_NAME = 'Exp 2';
  private static readonly BOOST_EXP_BOOST_2_DESCRIPTION = '+100% exp';

  private static readonly BOOST_COIN_BOOST_1_NAME = 'Coins 1';
  private static readonly BOOST_COIN_BOOST_1_DESCRIPTION =
    '+100% coins from monsters';
  private static readonly BOOST_COIN_BOOST_2_NAME = 'Coins 2';
  private static readonly BOOST_COIN_BOOST_2_DESCRIPTION =
    '+200% coins from monsters';

  private static readonly BOOST_POTION_DROP_1_NAME = 'Potion 1';
  private static readonly BOOST_POTION_DROP_1_DESCRIPTION =
    'Enable potion drop';
  private static readonly BOOST_POTION_DROP_2_NAME = 'Potion 2';
  private static readonly BOOST_POTION_DROP_2_DESCRIPTION =
    'More and better potions drop';

  private static readonly BOOST_MAX_POTIONS_1_NAME = 'Max potions 1';
  private static readonly BOOST_MAX_POTIONS_1_DESCRIPTION =
    'Custom potions capacity +1';
  private static readonly BOOST_MAX_POTIONS_2_NAME = 'Max potions 2';
  private static readonly BOOST_MAX_POTIONS_2_DESCRIPTION =
    'Custom potions capacity +2';
  private static readonly BOOST_MAX_POTIONS_3_NAME = 'Max potions 3';
  private static readonly BOOST_MAX_POTIONS_3_DESCRIPTION =
    'Custom potions capacity +3';

  private static readonly BOOST_PRAYER_1_NAME = 'Thor prayer';
  private static readonly BOOST_PRAYER_1_DESCRIPTION = '+100% dmg for 1h';

  private readonly seidhCommonBroadcasts: SeidhCommonBroadcasts;

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Boost.name) private boostModel: Model<Boost>,
    @InjectModel(BoostTransaction.name)
    private boostTransactionModel: Model<BoostTransaction>,
    @Inject(ServiceName.WsGateway) wsGatewayService: ClientProxy,
  ) {
    this.seidhCommonBroadcasts = new SeidhCommonBroadcasts(
      userModel,
      wsGatewayService,
    );
  }

  async onModuleInit() {
    const boosts = await this.boostModel.find();
    if (!boosts || boosts.length == 0) {
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_EXP_BOOST_1_NAME,
          description: BoostService.BOOST_EXP_BOOST_1_DESCRIPTION,
          order: 1,
          price: 100,
        }),
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_EXP_BOOST_2_NAME,
          description: BoostService.BOOST_EXP_BOOST_2_DESCRIPTION,
          order: 2,
          price: 100,
        }),
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_COIN_BOOST_1_NAME,
          description: BoostService.BOOST_COIN_BOOST_1_DESCRIPTION,
          order: 3,
          price: 100,
        }),
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_COIN_BOOST_2_NAME,
          description: BoostService.BOOST_COIN_BOOST_2_DESCRIPTION,
          order: 4,
          price: 100,
        }),
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_POTION_DROP_1_NAME,
          description: BoostService.BOOST_POTION_DROP_1_DESCRIPTION,
          order: 5,
          price: 100,
        }),
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_POTION_DROP_2_NAME,
          description: BoostService.BOOST_POTION_DROP_2_DESCRIPTION,
          order: 6,
          price: 100,
        }),
      );

      // this.boosts.push(
      //   await this.boostModel.create({
      //     name: BoostService.BOOST_MAX_POTIONS_1_NAME,
      //     description: BoostService.BOOST_MAX_POTIONS_1_DESCRIPTION,
      //     order: 5,
      //     price: 100,
      //   }),
      // );
      // this.boosts.push(
      //   await this.boostModel.create({
      //     name: BoostService.BOOST_MAX_POTIONS_2_NAME,
      //     description: BoostService.BOOST_MAX_POTIONS_2_DESCRIPTION,
      //     order: 6,
      //     price: 100,
      //   }),
      // );
      // this.boosts.push(
      //   await this.boostModel.create({
      //     name: BoostService.BOOST_MAX_POTIONS_3_NAME,
      //     description: BoostService.BOOST_MAX_POTIONS_3_DESCRIPTION,
      //     order: 7,
      //     price: 100,
      //   }),
      // );
      // this.boosts.push(
      //   await this.boostModel.create({
      //     name: BoostService.BOOST_PRAYER_1_NAME,
      //     description: BoostService.BOOST_PRAYER_1_DESCRIPTION,
      //     order: 8,
      //     price: 100,
      //   }),
      // );
    } else {
      this.boosts.push(...boosts);
    }
  }

  async getBoosts(request: BoostsGetServiceRequest) {
    const response: BoostsGetServiceResponse = {
      success: false,
    };

    const user = await this.userModel.findById(request.userId);
    if (!user) {
      response.message = 'User not found';
      return response;
    }

    const boosts = this.boosts
      .sort((a, b) => a.order - b.order)
      .map((boost) => {
        const boostBody: BoostBody = {
          id: boost.id,
          order: boost.order,
          name: boost.name,
          description: boost.description,
          price: boost.price,
          accquired: false,
        };

        switch (boost.name) {
          case BoostService.BOOST_EXP_BOOST_1_NAME:
            if (user.hasExpBoost1) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_EXP_BOOST_2_NAME:
            if (user.hasExpBoost2) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_COIN_BOOST_1_NAME:
            if (user.hasCoinBoost1) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_COIN_BOOST_2_NAME:
            if (user.hasCoinBoost2) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_POTION_DROP_1_NAME:
            if (user.hasPotionDropBoost1) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_POTION_DROP_2_NAME:
            if (user.hasPotionDropBoost2) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_MAX_POTIONS_1_NAME:
            if (user.hasMaxPotionBoost1) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_MAX_POTIONS_2_NAME:
            if (user.hasMaxPotionBoost2) {
              boostBody.accquired = true;
            }
            break;

          case BoostService.BOOST_MAX_POTIONS_3_NAME:
            if (user.hasMaxPotionBoost3) {
              boostBody.accquired = true;
            }
            break;
        }

        return boostBody;
      });

    response.success = true;
    response.boosts = boosts;

    return response;
  }

  async buyBoost(request: BoostsBuyBoostServiceRequest) {
    const response: BoostsBuyBoostServiceResponse = {
      success: false,
    };

    const boost = this.boosts.find((boost) => boost.id == request.boostId);
    if (!boost) {
      response.message = 'Boost not found';
      return response;
    }
    const user = await this.userModel.findById(request.userId);
    if (!user) {
      response.message = 'User not found';
      return response;
    }
    if (user.virtualTokenBalance < boost.price) {
      response.message = 'Not enough coins';
      return response;
    } else {
      user.virtualTokenBalance -= boost.price;
    }

    // Make sure that user does not have particular boost yet
    switch (boost.name) {
      case BoostService.BOOST_EXP_BOOST_1_NAME:
        if (!user.hasExpBoost1) {
          user.hasExpBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_EXP_BOOST_2_NAME:
        if (!user.hasExpBoost2) {
          user.hasExpBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_COIN_BOOST_1_NAME:
        if (!user.hasCoinBoost1) {
          user.hasExpBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_COIN_BOOST_2_NAME:
        if (!user.hasCoinBoost2) {
          user.hasExpBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_POTION_DROP_1_NAME:
        if (!user.hasPotionDropBoost1) {
          user.hasPotionDropBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_POTION_DROP_2_NAME:
        if (!user.hasPotionDropBoost2) {
          user.hasPotionDropBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_MAX_POTIONS_1_NAME:
        if (!user.hasMaxPotionBoost1) {
          user.hasMaxPotionBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_MAX_POTIONS_2_NAME:
        if (!user.hasMaxPotionBoost2) {
          user.hasMaxPotionBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_MAX_POTIONS_3_NAME:
        if (!user.hasMaxPotionBoost3) {
          user.hasMaxPotionBoost3 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_PRAYER_1_NAME:
        // TODO implement boost here
        break;
    }

    await user.save();
    await this.boostTransactionModel.create({
      boost,
      boostName: boost.name,
      user,
    });
    await this.seidhCommonBroadcasts.notifyBalanceUpdate(user.id);

    response.success = true;

    return response;
  }
}
