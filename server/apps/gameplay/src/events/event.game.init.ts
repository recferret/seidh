import { CharacterEntityFullStruct } from '@lib/seidh-common/types/types.engine';

import { EventGameBase } from './event.game.base';

export class EventGameInit implements EventGameBase {
  public static readonly EventName = 'game.init';
  gameId: string;
  charactersFullStruct: CharacterEntityFullStruct[];

  constructor(gameId: string, charactersFullStruct?: CharacterEntityFullStruct[]) {
    this.gameId = gameId;
    this.charactersFullStruct = charactersFullStruct;
  }
}
