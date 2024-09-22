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
  Boost = 3008,
  Character = 3009,
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
  Character = 'CharacterService',
  Referral = 'ReferralService',
  Collection = 'CollectionService',
  Game = 'GameService',
}

export class InternalProtocol {
  // TODO add redis url

  public static readonly NatsUrl = 'nats://0.0.0.0:4222';
  public static readonly MongoUrl = 'mongodb://localhost:27017/seidh';

  // public static readonly NatsUrl = 'nats://nats:4222';
  // public static readonly MongoUrl = 'mongodb://ferretrec:khlhasdg972^&*TFGy@mongodb:27017';
}
