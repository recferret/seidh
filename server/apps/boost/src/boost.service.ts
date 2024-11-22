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
      // ---------------------
      // BOOSTS
      // ---------------------

      this.boosts.push(
        await this.boostModel.create({
          order: 1,
          boostType: BoostType.Boost,

          levelOneId: 'TEETH',
          levelOneName: 'Golden teef',
          levelOneDescription: '100 golden teef',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Stars,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 2,
          boostType: BoostType.Boost,

          levelOneId: 'SALMON',
          levelOneName: 'Salmon',
          levelOneDescription: 'Salted! Heals 50% HP',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 3,
          boostType: BoostType.Boost,

          levelOneId: 'SWORD',
          levelOneName: 'Sword',
          levelOneDescription: 'Attack radius +50%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,
        }),
      );

      // ---------------------
      // RUNES
      // ---------------------

      // Exp
      this.boosts.push(
        await this.boostModel.create({
          order: 4,
          boostType: BoostType.Rune,

          levelZeroName: 'Exp 0/3',

          levelOneId: 'EXP_1',
          levelOneName: 'Exp 1/3',
          levelOneDescription: '50% more exp',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'EXP_2',
          levelTwoName: 'Exp 2/3',
          levelTwoDescription: '100% more exp',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'EXP_3',
          levelThreeName: 'Exp 3/3',
          levelThreeDescription: '300% more exp',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Item radius
      this.boosts.push(
        await this.boostModel.create({
          order: 5,
          boostType: BoostType.Rune,

          levelZeroName: 'Pick up 0/3',

          levelOneId: 'ITEM_RADIUS_1',
          levelOneName: 'Pick up 1/3',
          levelOneDescription: 'Pick up radius +50%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'ITEM_RADIUS_2',
          levelTwoName: 'Pick up 2/3',
          levelTwoDescription: 'Pick up radius +100%',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'ITEM_RADIUS_3',
          levelThreeName: 'Pick up 3/3',
          levelThreeDescription: 'Pick up radius +200%',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // More tokens
      this.boosts.push(
        await this.boostModel.create({
          order: 6,
          boostType: BoostType.Rune,

          levelZeroName: 'Coins 0/3',

          levelOneId: 'MORE_COINS_1',
          levelOneName: 'Coins 1/3',
          levelOneDescription: '100% more coins',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'MORE_COINS_2',
          levelTwoName: 'Coins 2/3',
          levelTwoDescription: '200% more coins',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'MORE_COINS_3',
          levelThreeName: 'Coins 3/3',
          levelThreeDescription: '400% more coins',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Monsters
      this.boosts.push(
        await this.boostModel.create({
          order: 7,
          boostType: BoostType.Rune,

          levelZeroName: 'Monsters 0/3',

          levelOneId: 'MONSTERS_1',
          levelOneName: 'Monsters 1/3',
          levelOneDescription: 'New types of monsters',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'MONSTERS_2',
          levelTwoName: 'Monsters 2/3',
          levelTwoDescription: 'More and stronger monsters',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'MONSTERS_3',
          levelThreeName: 'Monsters 3/3',
          levelThreeDescription: 'Stronger monsters and bosses',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Items drop
      this.boosts.push(
        await this.boostModel.create({
          order: 8,
          boostType: BoostType.Rune,

          levelZeroName: 'Items 0/3',

          levelOneId: 'ITEMS_DROP_1',
          levelOneName: 'Items 1/3',
          levelOneDescription: 'Health potions may drop',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'ITEMS_DROP_2',
          levelTwoName: 'Items 2/3',
          levelTwoDescription: 'Boost potions may drop',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'ITEMS_DROP_3',
          levelThreeName: 'Items 3/3',
          levelThreeDescription: 'More potions drop',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );
      // Stats
      this.boosts.push(
        await this.boostModel.create({
          order: 9,
          boostType: BoostType.Rune,

          levelZeroName: 'Stats 0/3',

          levelOneId: 'STATS_1',
          levelOneName: 'Stats 1/3',
          levelOneDescription: 'Stats boost +20%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Coins,

          levelTwoId: 'STATS_2',
          levelTwoName: 'Stats 2/3',
          levelTwoDescription: 'Stats boost +50%',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Coins,

          levelThreeId: 'STATS_3',
          levelThreeName: 'Stats 3/3',
          levelThreeDescription: 'Stats boost +100%',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );

      // ---------------------
      // SCROLLS
      // ---------------------

      this.boosts.push(
        await this.boostModel.create({
          order: 10,
          boostType: BoostType.Scroll,

          levelZeroName: 'Knowledge 0/3',

          levelOneId: 'KNOWLEDGE_1',
          levelOneName: 'Knowledge 1/3',
          levelOneDescription: 'Unlock LVL 1 upgrades',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Teeth,

          levelTwoId: 'KNOWLEDGE_2',
          levelTwoName: 'Knowledge 2/3',
          levelTwoDescription: 'Unlock LVL 2 upgrades',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.Teeth,

          levelThreeId: 'KNOWLEDGE_3',
          levelThreeName: 'Knowledge 3/3',
          levelThreeDescription: 'Unlock LVL 3 upgrades',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 11,
          boostType: BoostType.Scroll,

          levelZeroName: 'Thor might 0/3',

          levelOneId: 'THOR_MIGHT_1',
          levelOneName: 'Thor might 1/3',
          levelOneDescription: `Thor's strike!`,
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Teeth,

          levelTwoId: 'THOR_MIGHT_2',
          levelTwoName: 'Thor might 2/3',
          levelTwoDescription: `Super Thor's strike!`,
          levelTwoPrice: 100,
          levelTwoCurrencyType: CurrencyType.Teeth,

          levelThreeId: 'THOR_MIGHT_3',
          levelThreeName: 'Thor might 3/3',
          levelThreeDescription: `Ultimate Thor's strike!`,
          levelThreePrice: 100,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 12,
          boostType: BoostType.Scroll,

          levelZeroName: 'Skald song 0/3',

          levelOneId: 'SKALD_SONG_1',
          levelOneName: 'Skald song 1/3',
          levelOneDescription: `Full health and immortality!`,
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.Teeth,

          levelTwoId: 'SKALD_SONG_2',
          levelTwoName: 'Skald song 2/3',
          levelTwoDescription: `Freeze your enemies!`,
          levelTwoPrice: 100,
          levelTwoCurrencyType: CurrencyType.Teeth,

          levelThreeId: 'SKALD_SONG_3',
          levelThreeName: 'Skald song 3/3',
          levelThreeDescription: `Ultimate Thor's strike!`,
          levelThreePrice: 100,
          levelThreeCurrencyType: CurrencyType.Teeth,
        }),
      );

      // ---------------------
      // ARTIFACTS
      // ---------------------

      // Valkyre feather
      this.boosts.push(
        await this.boostModel.create({
          order: 13,
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

          levelZeroName: boost.levelZeroName,

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
    response.boosts = await this.getBoostsByUserId(request.userId);

    return response;
  }

  private async getBoostsByUserId(userId: string) {
    const user = await this.userModel.findById(userId);

    const boosts = this.boosts
      .sort((a, b) => a.order - b.order)
      .map((boost) => {
        const boostBody: BoostBody = {
          order: boost.order,

          boostType: boost.boostType,

          levelZeroName: boost.levelZeroName,

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

    return boosts;
  }
}
