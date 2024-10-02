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
  BoostType,
  CurrencyType,
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
      // Exp
      this.boosts.push(
        await this.boostModel.create({
          order: 1,
          boostType: BoostType.Rune,

          levelOneId: 'EXP_1',
          levelOneName: 'Exp +50%',
          levelOneDescription: 'More exp per monster kill',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'EXP_2',
          levelTwoName: 'Exp +100%',
          levelTwoDescription: 'Even more exp per monster kill',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'EXP_3',
          levelThreeName: 'Exp +200%',
          levelThreeDescription: 'Three time more exp per monster kill',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Item radius
      this.boosts.push(
        await this.boostModel.create({
          order: 2,
          boostType: BoostType.Rune,

          levelOneId: 'ITEM_RADIUS_1',
          levelOneName: 'Pick up radius +100%',
          levelOneDescription: 'Better items pick up radius',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'ITEM_RADIUS_2',
          levelTwoName: 'Pick up radius +200%',
          levelTwoDescription: 'Even better items pick up radius',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'ITEM_RADIUS_3',
          levelThreeName: 'Pick up radius +300%',
          levelThreeDescription: 'Best items pick up radius',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // More tokens
      this.boosts.push(
        await this.boostModel.create({
          order: 3,
          boostType: BoostType.Rune,

          levelOneId: 'MORE_TOKENS_1',
          levelOneName: 'Double tokens gained',
          levelOneDescription: 'X2 tokens from monsters',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'MORE_TOKENS_2',
          levelTwoName: 'Triple tokens gained',
          levelTwoDescription: 'X3 tokens from monsters',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'MORE_TOKENS_3',
          levelThreeName: 'Quadruple tokens gained',
          levelThreeDescription: 'X4 tokens from monsters',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Monsters
      this.boosts.push(
        await this.boostModel.create({
          order: 4,
          boostType: BoostType.Rune,

          levelOneId: 'MONSTERS_1',
          levelOneName: 'Monsters 1',
          levelOneDescription: 'More and stronger monsters',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'MONSTERS_2',
          levelTwoName: 'Monsters 2',
          levelTwoDescription: 'New types of monsters',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'MONSTERS_2',
          levelThreeName: 'Monsters 3',
          levelThreeDescription: 'New types of monsters and bosses',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Items drop
      this.boosts.push(
        await this.boostModel.create({
          order: 5,
          boostType: BoostType.Scroll,

          levelOneId: 'ITEMS_DROP_1',
          levelOneName: 'Items drop 1',
          levelOneDescription: 'Health potions may drop',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'ITEMS_DROP_2',
          levelTwoName: 'Items drop 2',
          levelTwoDescription: 'Boost potions may drop',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'ITEMS_DROP_3',
          levelThreeName: 'Items drop 3',
          levelThreeDescription: 'More potions drop',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Stats
      this.boosts.push(
        await this.boostModel.create({
          order: 6,
          boostType: BoostType.Scroll,

          levelOneId: 'STATS_1',
          levelOneName: 'Better stats 1',
          levelOneDescription: 'Stats boost +20%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'STATS_2',
          levelTwoName: 'Better stats 2',
          levelTwoDescription: 'Stats boost +50%',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'STATS_2',
          levelThreeName: 'Better stats 3',
          levelThreeDescription: 'Stats boost +100%',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Artrifact
      this.boosts.push(
        await this.boostModel.create({
          order: 7,
          boostType: BoostType.Artifact,

          levelOneId: 'ARTIFACT_1',
          levelOneName: "Valkyrie's feather",
          levelOneDescription: 'Revive once a game',
          levelOnePrice: 5,
          levelOneCurrencyType: CurrencyType.Teeth,
        }),
      );
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
          order: boost.order,

          boostType: boost.boostType,

          levelOneId: boost.levelOneId,
          levelOneName: boost.levelOneName,
          levelOneDescription: boost.levelOneDescription,
          levelOnePrice: boost.levelOnePrice,
          levelOneCurrencyType: boost.levelOneCurrencyType,
          levelOneAccquired: false,

          levelTwoId: boost.levelTwoId,
          levelTwoName: boost.levelTwoName,
          levelTwoDescription: boost.levelTwoDescription,
          levelTwoPrice: boost.levelTwoPrice,
          levelTwoCurrencyType: boost.levelTwoCurrencyType,
          levelTwoAccquired: false,

          levelThreeId: boost.levelThreeId,
          levelThreeName: boost.levelThreeName,
          levelThreeDescription: boost.levelThreeDescription,
          levelThreePrice: boost.levelThreePrice,
          levelThreeCurrencyType: boost.levelThreeCurrencyType,
          levelThreeAccquired: false,
        };

        if (user.boostsOwned.includes(boostBody.levelOneId)) {
          boostBody.levelOneAccquired = true;
        }
        if (user.boostsOwned.includes(boostBody.levelTwoId)) {
          boostBody.levelTwoAccquired = true;
        }
        if (user.boostsOwned.includes(boostBody.levelThreeId)) {
          boostBody.levelThreeAccquired = true;
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

    const boost = this.boosts.find(
      (boost) =>
        boost.levelOneId == request.boostId ||
        boost.levelTwoId == request.boostId ||
        boost.levelThreeId == request.boostId,
    );
    // Has such boost
    if (!boost) {
      response.message = 'Boost not found';
      return response;
    }
    // Has such user
    const user = await this.userModel.findById(request.userId);
    if (!user) {
      response.message = 'User not found';
      return response;
    }
    // User has such boost
    if (user.boostsOwned.includes(request.boostId)) {
      response.message = 'Already owned';
      return response;
    }
    // User has enough coins
    let currencyType = CurrencyType.Coins;
    let price = 0;
    if (request.boostId.includes('1')) {
      currencyType = boost.levelOneCurrencyType;
      price = boost.levelOnePrice;
    } else if (request.boostId.includes('2')) {
      // Check if level 1 owned
      if (!user.boostsOwned.includes(boost.levelOneId)) {
        response.message = 'Need level 1 first';
        return response;
      }

      currencyType = boost.levelTwoCurrencyType;
      price = boost.levelTwoPrice;
    } else if (request.boostId.includes('3')) {
      // Check if level 2 owned
      if (!user.boostsOwned.includes(boost.levelTwoId)) {
        response.message = 'Need level 2 first';
        return response;
      }

      currencyType = boost.levelThreeCurrencyType;
      price = boost.levelThreePrice;
    }
    // Has enough coins
    if (
      (currencyType == CurrencyType.Coins && price > user.coins) ||
      (currencyType == CurrencyType.Teeth && price > user.teeth)
    ) {
      response.message = 'Not enough money';
      return response;
    }
    // OK flow, spent money
    if (currencyType == CurrencyType.Coins) {
      user.coins -= price;
    } else if (currencyType == CurrencyType.Teeth) {
      user.teeth -= price;
    }
    // add boost
    user.boostsOwned.push(request.boostId);
    // save and notify about balance change
    await user.save();
    await this.boostTransactionModel.create({
      boost,
      boostId: request.boostId,
      user,
    });
    await this.seidhCommonBroadcasts.notifyBalanceUpdate(user.id);
    response.success = true;
    return response;
  }
}
