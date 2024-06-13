export interface WsGameEvent {
    broadcast: boolean;
    gameplayServiceId: string;
    gameId?: string;
    playerId?: string;
}

export enum ServicePort {
    TG = 3008,
    Gameplay = 3001,
    GameplayLobby = 3002,
    Gateway = 3003,
    WsGateway = 3004,
    Auth = 3005,
    Users = 3006,
}

export enum ServiceName {
    TG = 'TGService',
    Gameplay = 'GameplayService',
    GameplayLobby = 'GameplayLobbyService',
    Gateway = 'GatewayService',
    WsGateway = 'WsGatewayService',
    Auth = 'AuthService',
    Users = 'UsersService',
}

export class InternalProtocol {
    // public static readonly NatsUrl = 'nats://0.0.0.0:4222';
    public static readonly NatsUrl = 'nats://nats:4222';
    // public static readonly MongoUrl = 'mongodb://localhost:27017/seidh';
    public static readonly MongoUrl = 'mongodb://mongodb:27017';
}
