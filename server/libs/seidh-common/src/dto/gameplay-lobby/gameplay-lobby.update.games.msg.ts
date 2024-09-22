import { GameplayType } from './gameplay-lobby.find.game.msg';

export const GameplayLobbyUpdateGamesPattern = 'gameplay-lobby.update.games';

export interface GameplayLobbyGameInfo {
  gameId: string;
  gameplayType: GameplayType;
  lastDt: number;
  users: number;
  mobs: number;
}

export interface GameplayLobbyGameplayInstanceInfo {
  gameplayServiceId: string;
  games: GameplayLobbyGameInfo[];
  lastUpdateTime?: number;
}

export interface GameplayLobbyUpdateGamesServiceMessage
  extends GameplayLobbyGameplayInstanceInfo {}
