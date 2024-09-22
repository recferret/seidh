export const GameplayLobbyFindGamePattern = 'gameplay-lobby.find.game';

export enum GameplayType {
  PrivateGame = 'PrivateGame',
  PublicGame = 'PublicGame',
  TestGame = 'TestGame',
}

export interface GameplayLobbyFindGameServiceRequest {
  userId: string;
  gameplayType: GameplayType;
  gameId?: string;
}

export interface GameplayLobbyFindGameServiceResponse {
  success: boolean;
  reason?: string;
  gameplayServiceId?: string;
  gameId?: string;
}
