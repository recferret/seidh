export enum GameType {
  Single = 'Single',
}

export enum GameState {
  Playing = 'Playing',
  Finished = 'Finished',
}

export enum GameFinishReason {
  Win = 'Win',
  Lose = 'Lose',
  Timeout = 'Timeout',
  Closed = 'Closed',
}

export interface GameGainings {
  zombiesKilled: number;
  coinsGained: number;
}
