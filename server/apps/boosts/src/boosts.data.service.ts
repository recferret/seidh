import { Boost, BoostDocument } from '@lib/seidh-common/schemas/boost/schema.boost';
import { Model } from 'mongoose';

import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import { BoostType } from '@lib/seidh-common/types/types.boost';
import { CurrencyType } from '@lib/seidh-common/types/types.user';

@Injectable()
export class BoostsDataService implements OnModuleInit {
  public readonly boosts: Array<BoostDocument> = [];

  constructor(@InjectModel(Boost.name) private boostModel: Model<Boost>) {}

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
          levelOneDescription1: '100 golden teef',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.STARS,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 2,
          boostType: BoostType.Boost,

          levelOneId: 'SALMON',
          levelOneName: 'Salmon',
          levelOneDescription1: 'Salted! Heals 50% HP',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 3,
          boostType: BoostType.Boost,

          levelOneId: 'SWORD',
          levelOneName: 'Sword',
          levelOneDescription1: 'Attack radius +50%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,
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
          levelOneDescription1: '50% more exp',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,

          levelTwoId: 'EXP_2',
          levelTwoName: 'Exp 2/3',
          levelTwoDescription1: '100% more exp',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.COINS,

          levelThreeId: 'EXP_3',
          levelThreeName: 'Exp 3/3',
          levelThreeDescription1: '300% more exp',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.COINS,
        }),
      );
      // Item radius
      this.boosts.push(
        await this.boostModel.create({
          order: 5,
          boostType: BoostType.Rune,

          levelZeroName: 'Wealth 0/3',

          levelOneId: 'WEALTH_1',
          levelOneName: 'Wealth 1/3',
          levelOneDescription1: 'Coins income +100%',
          levelOneDescription2: 'Pick up radius +50%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,

          levelTwoId: 'WEALTH_2',
          levelTwoName: 'Wealth 2/3',
          levelTwoDescription1: 'Coins income +200%',
          levelTwoDescription2: 'Pick up radius +100%',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.COINS,

          levelThreeId: 'WEALTH_3',
          levelThreeName: 'Wealth 3/3',
          levelThreeDescription1: 'Coins income +300%',
          levelThreeDescription2: 'Pick up radius +150%',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.COINS,
        }),
      );
      // More tokens
      this.boosts.push(
        await this.boostModel.create({
          order: 6,
          boostType: BoostType.Rune,

          levelZeroName: 'Attack 0/3',

          levelOneId: 'ATTACK_1',
          levelOneName: 'Attack 1/3',
          levelOneDescription1: '100% more coins',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,

          levelTwoId: 'ATTACK_2',
          levelTwoName: 'Attack 2/3',
          levelTwoDescription1: '200% more coins',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.COINS,

          levelThreeId: 'ATTACK_3',
          levelThreeName: 'Attack 3/3',
          levelThreeDescription1: '400% more coins',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.COINS,
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
          levelOneDescription1: 'New types of monsters',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,

          levelTwoId: 'MONSTERS_2',
          levelTwoName: 'Monsters 2/3',
          levelTwoDescription1: 'More and stronger monsters',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.COINS,

          levelThreeId: 'MONSTERS_3',
          levelThreeName: 'Monsters 3/3',
          levelThreeDescription1: 'Stronger monsters and bosses',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.COINS,
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
          levelOneDescription1: 'Health potions may drop',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,

          levelTwoId: 'ITEMS_DROP_2',
          levelTwoName: 'Items 2/3',
          levelTwoDescription1: 'Boost potions may drop',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.COINS,

          levelThreeId: 'ITEMS_DROP_3',
          levelThreeName: 'Items 3/3',
          levelThreeDescription1: 'More potions drop',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.COINS,
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
          levelOneDescription1: 'Stats boost +20%',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.COINS,

          levelTwoId: 'STATS_2',
          levelTwoName: 'Stats 2/3',
          levelTwoDescription1: 'Stats boost +50%',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.COINS,

          levelThreeId: 'STATS_3',
          levelThreeName: 'Stats 3/3',
          levelThreeDescription1: 'Stats boost +100%',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.COINS,
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
          levelOneDescription1: 'Unlock LVL 1 upgrades',
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.TEETH,

          levelTwoId: 'KNOWLEDGE_2',
          levelTwoName: 'Knowledge 2/3',
          levelTwoDescription1: 'Unlock LVL 2 upgrades',
          levelTwoPrice: 500,
          levelTwoCurrencyType: CurrencyType.TEETH,

          levelThreeId: 'KNOWLEDGE_3',
          levelThreeName: 'Knowledge 3/3',
          levelThreeDescription1: 'Unlock LVL 3 upgrades',
          levelThreePrice: 1000,
          levelThreeCurrencyType: CurrencyType.TEETH,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 11,
          boostType: BoostType.Scroll,

          levelZeroName: 'Thor might 0/3',

          levelOneId: 'THOR_MIGHT_1',
          levelOneName: 'Thor might 1/3',
          levelOneDescription1: `Thor's strike!`,
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.TEETH,

          levelTwoId: 'THOR_MIGHT_2',
          levelTwoName: 'Thor might 2/3',
          levelTwoDescription1: `Super Thor's strike!`,
          levelTwoPrice: 100,
          levelTwoCurrencyType: CurrencyType.TEETH,

          levelThreeId: 'THOR_MIGHT_3',
          levelThreeName: 'Thor might 3/3',
          levelThreeDescription1: `Ultimate Thor's strike!`,
          levelThreePrice: 100,
          levelThreeCurrencyType: CurrencyType.TEETH,
        }),
      );

      this.boosts.push(
        await this.boostModel.create({
          order: 12,
          boostType: BoostType.Scroll,

          levelZeroName: 'Skald song 0/3',

          levelOneId: 'SKALD_SONG_1',
          levelOneName: 'Skald song 1/3',
          levelOneDescription1: `Full health and immortality!`,
          levelOnePrice: 100,
          levelOneCurrencyType: CurrencyType.TEETH,

          levelTwoId: 'SKALD_SONG_2',
          levelTwoName: 'Skald song 2/3',
          levelTwoDescription1: `Freeze your enemies!`,
          levelTwoPrice: 100,
          levelTwoCurrencyType: CurrencyType.TEETH,

          levelThreeId: 'SKALD_SONG_3',
          levelThreeName: 'Skald song 3/3',
          levelThreeDescription1: `Ultimate Thor's strike!`,
          levelThreePrice: 100,
          levelThreeCurrencyType: CurrencyType.TEETH,
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
          levelOneDescription1: 'Revive once a game',
          levelOnePrice: 5,
          levelOneCurrencyType: CurrencyType.TEETH,
        }),
      );
    } else {
      this.boosts.push(...boosts);
    }
  }
}
