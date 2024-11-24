export class GameServiceProgressGameRequestDto {
  gameId: string;
  mobsKilled: number;
  tokensGained: number;
}

export class GameServiceProgressGameResponseDto {
  salt: string;
}
