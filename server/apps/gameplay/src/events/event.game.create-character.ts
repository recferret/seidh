import { CharacterEntityFullStruct } from '@lib/seidh-common/types/types.engine';

import { EventGameBase } from './event.game.base';

export class EventGameCreateCharacter implements EventGameBase {
  public static readonly EventName = 'game.create-character';
  gameId: string;
  characterEntityFullStruct: CharacterEntityFullStruct;

  constructor(gameId: string, characterEntityFullStruct: CharacterEntityFullStruct) {
    this.gameId = gameId;
    this.characterEntityFullStruct = characterEntityFullStruct;
  }
}
