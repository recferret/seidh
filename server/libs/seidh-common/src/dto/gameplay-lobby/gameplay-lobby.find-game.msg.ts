import { BasicServiceResponse } from '../basic.msg';

export const GameplayServiceLobbyFindGamePattern = 'gameplay-lobby.find.game';

export enum GameplayType {
  PrivateGame = 'PrivateGame',
  PublicGame = 'PublicGame',
  TestGame = 'TestGame',
}

export interface GameplayServiceLobbyFindGameRequest {
  userId: string;
  gameplayType: GameplayType;
  gameId?: string;
}

export interface GameplayServiceLobbyFindGameResponse extends BasicServiceResponse {
  gameplayServiceId?: string;
  gameId?: string;
}
