export const GameplayLobbyFindGamePattern = 'gameplay-lobby.find.game';

export enum GameType {
  PrivateGame = 'PrivateGame',
  PublicGame = 'PublicGame',
  TestGame = 'TestGame',
  //GroupGame = 'GroupGame',
}

export interface GameplayLobbyFindGameMessageRequest {
  userId: string;
  gameId?: string;
  gameType?: GameType;
}

export interface GameplayLobbyFindGameMessageResponse {
  gameplayServiceId: string;
  gameplayId?: string;
}
