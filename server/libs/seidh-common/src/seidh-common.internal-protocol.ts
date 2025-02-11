export interface WsGameEvent {
  broadcast: boolean;
  gameplayServiceId: string;
  gameId?: string;
  userId?: string;
}

export enum ServicePort {
  Gameplay = 3001,
  GameplayLobby = 3002,
  GameplayWorker = 3003,
  Gateway = 3004,
  WsGateway = 3005,
  Users = 3006,
  TG = 3007,
  Boosts = 3008,
  Characters = 3009,
  Referral = 3010,
  Collection = 3011,
  Game = 3012,
}

export enum ServiceName {
  TG = 'TGService',
  Gameplay = 'GameplayService',
  GameplayLobby = 'GameplayLobbyService',
  Gateway = 'GatewayService',
  WsGateway = 'WsGatewayService',
  Auth = 'AuthService',
  Users = 'UsersService',
  Boost = 'BoostService',
  Characters = 'CharactersService',
  Referral = 'ReferralService',
  Collection = 'CollectionService',
  Game = 'GameService',
}

export const NatsUrl = `nats://localhost:4222`;
// export const NatsUrl = `nats://nats:4222`;
// export const NatsUrl = `nats://${process.env.NATS_HOST}:${process.env.NATS_PORT}`;
