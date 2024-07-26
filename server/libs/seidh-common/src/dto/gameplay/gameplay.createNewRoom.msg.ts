import { GameType } from '@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg';

export const GameplayCreateNewGamePattern = 'gameplay.create.new.game.room';

export interface GameplayCreateNewRoomMsg {
  gameType: GameType;
}

export interface GameplayCreatedRoomMsg {
  gameInstance: string;
  gamePlayInstance: string;
}
