export interface WsGameEvent {
    broadcast: boolean;
    gameplayServiceId: string;
    gameId?: string;
    playerId?: string;
}

export enum ServicePort {
    Gameplay = 3001,
    GameplayLobby = 3002,
    Gateway = 3003,
    WsGateway = 3004,
    Users = 3005,
    TG = 3006,
    Boost = 3007,
    Character = 3008,
    Referral = 3009,
    Collection = 3010,
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
}

export class InternalProtocol {
    public static readonly NatsUrl = 'nats://0.0.0.0:4222';
    public static readonly MongoUrl = 'mongodb://localhost:27017/seidh';

    // public static readonly NatsUrl = 'nats://nats:4222';
    // public static readonly MongoUrl = 'mongodb://ferretrec:khlhasdg972^&*TFGy@mongodb:27017';
}
