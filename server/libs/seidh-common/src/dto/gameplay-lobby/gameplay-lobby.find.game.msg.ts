export const GameplayLobbyFindGamePattern = 'gameplay-lobby.find.game';

export enum GameType {
  PrivateGame = 'PrivateGame',
  PublicGame = 'PublicGame',
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
