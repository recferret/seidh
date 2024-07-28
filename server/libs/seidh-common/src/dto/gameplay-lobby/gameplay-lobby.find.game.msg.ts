export const GameplayLobbyFindGamePattern = 'gameplay-lobby.find.game';

export enum GameType {
  PrivateGame = 'PrivateGame',
  PublicGame = 'PublicGame',
  TestGame = 'TestGame',
}

export interface GameplayLobbyFindGameMessageRequest {
  userId: string;
  gameType: GameType;
  gameId?: string;
}

export interface GameplayLobbyFindGameMessageResponse {
  success: boolean;
  reason?: string;
  gameplayServiceId?: string;
  gameId?: string;
}
