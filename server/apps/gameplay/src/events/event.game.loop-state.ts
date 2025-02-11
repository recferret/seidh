import { CharacterEntityMinStruct } from '@lib/seidh-common/types/types.engine';

import { EventGameBase } from './event.game.base';

export class EventGameLoopState implements EventGameBase {
  public static readonly EventName = 'game.loop-state';
  gameId: string;
  charactersMinStruct: CharacterEntityMinStruct[];

  constructor(gameId: string, charactersMinStruct: CharacterEntityMinStruct[]) {
    this.gameId = gameId;
    this.charactersMinStruct = charactersMinStruct;
  }
}
