export class GameServiceProgressGameRequestDto {
  gameId: string;
  zombiesKilled: number;
  coinsGained: number;
}

export class GameServiceProgressGameResponseDto {
  success: boolean;
}
