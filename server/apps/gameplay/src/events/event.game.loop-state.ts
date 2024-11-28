import { CharacterEntityMinStruct } from '@app/seidh-common/seidh-common.boost-constants';
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
