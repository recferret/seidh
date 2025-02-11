import { SeidhCommonBoostsData } from './seidh-common.boosts-data';

export class SeidhCommonBoostsUtils {
  public static GetUserExpLevel(boostsOwned: string[]) {
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_EXP_3_ID)) return 3;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_EXP_2_ID)) return 2;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_EXP_1_ID)) return 1;
    return 0;
  }

  public static GetUserWealthLevel(boostsOwned: string[]) {
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_WEALTH_3_ID)) return 3;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_WEALTH_2_ID)) return 2;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_WEALTH_1_ID)) return 1;
    return 0;
  }

  public static GetUserAttackLevel(boostsOwned: string[]) {
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_ATTACK_3_ID)) return 3;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_ATTACK_2_ID)) return 2;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_ATTACK_1_ID)) return 1;
    return 0;
  }

  public static GetUserMonstersLevel(boostsOwned: string[]) {
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_MONSTERS_3_ID)) return 3;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_MONSTERS_2_ID)) return 2;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_MONSTERS_1_ID)) return 1;
    return 0;
  }

  public static GetUserItemsLevel(boostsOwned: string[]) {
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_ITEMS_DROP_3_ID)) return 3;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_ITEMS_DROP_2_ID)) return 2;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_ITEMS_DROP_1_ID)) return 1;
    return 0;
  }

  public static GetUserStatsLevel(boostsOwned: string[]) {
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_STATS_3_ID)) return 3;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_STATS_2_ID)) return 2;
    if (boostsOwned.includes(SeidhCommonBoostsData.BOOST_STATS_1_ID)) return 1;
    return 0;
  }

  public static GetExpMultiplierByLevel(level: number) {
    switch (level) {
      case 3:
        return SeidhCommonBoostsData.BOOST_EXP_3_MULTIPLIER;
      case 2:
        return SeidhCommonBoostsData.BOOST_EXP_2_MULTIPLIER;
      case 1:
        return SeidhCommonBoostsData.BOOST_EXP_1_MULTIPLIER;
      default:
        return 1;
    }
  }

  public static GetWealthRadiusMultiplierByLevel(level: number) {
    switch (level) {
      case 3:
        return SeidhCommonBoostsData.BOOST_WEALTH_3_RADIUS_MULTIPLIER;
      case 2:
        return SeidhCommonBoostsData.BOOST_WEALTH_2_RADIUS_MULTIPLIER;
      case 1:
        return SeidhCommonBoostsData.BOOST_WEALTH_1_RADIUS_MULTIPLIER;
      default:
        return 1;
    }
  }

  public static GetWealthCoinsMultiplierByLevel(level: number) {
    switch (level) {
      case 3:
        return SeidhCommonBoostsData.BOOST_WEALTH_3_COINS_MULTIPLIER;
      case 2:
        return SeidhCommonBoostsData.BOOST_WEALTH_2_COINS_MULTIPLIER;
      case 1:
        return SeidhCommonBoostsData.BOOST_WEALTH_1_COINS_MULTIPLIER;
      default:
        return 1;
    }
  }

  public static GetStatsMultiplierByLevel(level: number) {
    switch (level) {
      case 3:
        return SeidhCommonBoostsData.BOOST_STATS_3_MULTIPLIER;
      case 2:
        return SeidhCommonBoostsData.BOOST_STATS_2_MULTIPLIER;
      case 1:
        return SeidhCommonBoostsData.BOOST_STATS_1_MULTIPLIER;
      default:
        return 1;
    }
  }
}
