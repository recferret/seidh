export class SeidhCommonBoostConstants {

    // IDs
    public static readonly BOOST_TEETH_ID = 'TEETH';
    public static readonly BOOST_SALMON_ID = 'SALMON';
    public static readonly BOOST_SWORD_ID = 'SWORD';

    public static readonly BOOST_EXP_1_ID = 'EXP_1';
    public static readonly BOOST_EXP_2_ID = 'EXP_2';
    public static readonly BOOST_EXP_3_ID = 'EXP_3';

    public static readonly BOOST_WEALTH_1_ID = 'WEALTH_1';
    public static readonly BOOST_WEALTH_2_ID = 'WEALTH_2';
    public static readonly BOOST_WEALTH_3_ID = 'WEALTH_3';

    public static readonly BOOST_ATTACK_1_ID = 'ATTACK_1';
    public static readonly BOOST_ATTACK_2_ID = 'ATTACK_2';
    public static readonly BOOST_ATTACK_3_ID = 'ATTACK_3';

    public static readonly BOOST_MONSTERS_1_ID = 'MONSTERS_1';
    public static readonly BOOST_MONSTERS_2_ID = 'MONSTERS_2';
    public static readonly BOOST_MONSTERS_3_ID = 'MONSTERS_3';
    
    public static readonly BOOST_ITEMS_DROP_1_ID = 'ITEMS_DROP_1';
    public static readonly BOOST_ITEMS_DROP_2_ID = 'ITEMS_DROP_2';
    public static readonly BOOST_ITEMS_DROP_3_ID = 'ITEMS_DROP_3';

    public static readonly BOOST_STATS_1_ID = 'STATS_1';
    public static readonly BOOST_STATS_2_ID = 'STATS_2';
    public static readonly BOOST_STATS_3_ID = 'STATS_3';

    public static readonly BOOST_KNOWLEDGE_1_ID = 'KNOWLEDGE_1';
    public static readonly BOOST_KNOWLEDGE_2_ID = 'KNOWLEDGE_2';
    public static readonly BOOST_KNOWLEDGE_3_ID = 'KNOWLEDGE_3';

    public static readonly BOOST_THOR_MIGHT_1_ID = 'THOR_MIGHT_1';
    public static readonly BOOST_THOR_MIGHT_2_ID = 'THOR_MIGHT_2';
    public static readonly BOOST_THOR_MIGHT_3_ID = 'THOR_MIGHT_3';

    public static readonly BOOST_SKALD_SONG_1_ID = 'SKALD_SONG_1';
    public static readonly BOOST_SKALD_SONG_2_ID = 'SKALD_SONG_2';
    public static readonly BOOST_SKALD_SONG_3_ID = 'SKALD_SONG_3';

    public static readonly BOOST_ARTIFACT_1_ID = 'ARTIFACT_1';

    // Effects
    public static readonly BOOST_EXP_1_MULTIPLIER = 1.5;
    public static readonly BOOST_EXP_2_MULTIPLIER = 2;
    public static readonly BOOST_EXP_3_MULTIPLIER = 3;

    public static readonly BOOST_WEALTH_1_RADIUS_MULTIPLIER = 1.2;
    public static readonly BOOST_WEALTH_2_RADIUS_MULTIPLIER = 1.5;
    public static readonly BOOST_WEALTH_3_RADIUS_MULTIPLIER = 2;

    public static readonly BOOST_WEALTH_1_COINS_MULTIPLIER = 2;
    public static readonly BOOST_WEALTH_2_COINS_MULTIPLIER = 3;
    public static readonly BOOST_WEALTH_3_COINS_MULTIPLIER = 4;

    public static readonly BOOST_STATS_1_MULTIPLIER = 1.2;
    public static readonly BOOST_STATS_2_MULTIPLIER = 1.5;
    public static readonly BOOST_STATS_3_MULTIPLIER = 2;

    public static GetExpMultiplierByLevel(level: number) {
        switch (level) {
            case 3:
                return SeidhCommonBoostConstants.BOOST_EXP_3_MULTIPLIER;
            case 2:
                return SeidhCommonBoostConstants.BOOST_EXP_2_MULTIPLIER;
            case 1:
                return SeidhCommonBoostConstants.BOOST_EXP_1_MULTIPLIER;
            default:
                return 1;
        }
    }

    public static GetWealthRadiusMultiplierByLevel(level: number) {
        switch (level) {
            case 3:
                return SeidhCommonBoostConstants.BOOST_WEALTH_3_RADIUS_MULTIPLIER;
            case 2:
                return SeidhCommonBoostConstants.BOOST_WEALTH_2_RADIUS_MULTIPLIER;
            case 1:
                return SeidhCommonBoostConstants.BOOST_WEALTH_1_RADIUS_MULTIPLIER;
            default:
                return 1;
        }
    }

    public static GetWealthCoinsMultiplierByLevel(level: number) {
        switch (level) {
            case 3:
                return SeidhCommonBoostConstants.BOOST_WEALTH_3_COINS_MULTIPLIER;
            case 2:
                return SeidhCommonBoostConstants.BOOST_WEALTH_2_COINS_MULTIPLIER;
            case 1:
                return SeidhCommonBoostConstants.BOOST_WEALTH_1_COINS_MULTIPLIER;
            default:
                return 1;
        }
    }

    public static GetStatsMultiplierByLevel(level: number) {
        switch (level) {
            case 3:
                return SeidhCommonBoostConstants.BOOST_STATS_3_MULTIPLIER;
            case 2:
                return SeidhCommonBoostConstants.BOOST_STATS_2_MULTIPLIER;
            case 1:
                return SeidhCommonBoostConstants.BOOST_STATS_1_MULTIPLIER;
            default:
                return 1;
        }
    }

}