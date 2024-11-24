export class GameServiceGetGameConfigResponseDto {
  success: boolean;

  // Mobs spawn
  mobsMaxAtTheSameTime?: number;
  mobsMaxPerGame?: number;
  mobSpawnDelayMs?: number;

  // Exp boost
  expLevel1Multiplier?: number;
  expLevel2Multiplier?: number;
  expLevel3Multiplier?: number;

  // Stats boost
  statsLevel1Multiplier?: number;
  statsLevel2Multiplier?: number;
  statsLevel3Multiplier?: number;

  // Wealth boost
  wealthLevel1PickUpRangeMultiplier?: number;
  wealthLevel2PickUpRangeMultiplier?: number;
  wealthLevel3PickUpRangeMultiplier?: number;

  wealthLevel1CoinsMultiplier?: number;
  wealthLevel2CoinsMultiplier?: number;
  wealthLevel3CoinsMultiplier?: number;
}
