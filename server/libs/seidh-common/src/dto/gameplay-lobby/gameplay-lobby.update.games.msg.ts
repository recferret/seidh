import { GameType } from "./gameplay-lobby.find.game.msg";

export const GameplayLobbyUpdateGamesPattern = 'gameplay-lobby.update.games';

export interface GameplayLobbyGameInfo {
    gameId: string;
    gameType: GameType;
    playersOnline: number;
}

export interface GameplayLobbyGameplayInstanceInfo {
    gameplayServiceId: string;
    games: GameplayLobbyGameInfo[];
    lastUpdateTime?: number;
}

export interface GameplayLobbyUpdateGamesMessage extends GameplayLobbyGameplayInstanceInfo{
}