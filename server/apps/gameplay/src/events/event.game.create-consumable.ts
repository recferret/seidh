import { ConsumableEntityStruct } from '@lib/seidh-common/types/types.engine';

import { EventGameBase } from './event.game.base';

export class EventGameCreateConsumable implements EventGameBase {
  public static readonly EventName = 'game.create-consumable';
  gameId: string;
  consumableEntityStruct: ConsumableEntityStruct;

  constructor(gameId: string, consumableEntityStruct: ConsumableEntityStruct) {
    this.gameId = gameId;
    this.consumableEntityStruct = consumableEntityStruct;
  }
}
