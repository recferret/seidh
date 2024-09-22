export class GameProgressGameRequestDto {
  gameId: string;
  mobsKilled: number;
  tokensGained: number;
}

export class GameProgressGameResponseDto {
  salt: string;
}
