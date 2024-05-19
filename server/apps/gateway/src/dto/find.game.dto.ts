import { GameType } from "@app/seidh-common/dto/gameplay-lobby/gameplay-lobby.find.game.msg";

export class FindGameRequest {
    playerId: string;
    gameType?: GameType;
}

export class FindGameResponse {
    gameplayServiceId: string;
    gameId?: string;
}