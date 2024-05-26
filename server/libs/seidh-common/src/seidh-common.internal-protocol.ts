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
}

export enum ServiceName {
    TG = 'TGService',
    Gameplay = 'GameplayService',
    GameplayLobby = 'GameplayLobbyService',
    Gateway = 'GatewayService',
    WsGateway = 'WsGatewayService',
    Auth = 'AuthService',
}

const NatsUrl = 'nats://0.0.0.0:4222';
// const NatsUrl = 'nats://nats:4222';

export default NatsUrl;