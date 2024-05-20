export interface WsGameEvent {
    broadcast: boolean;
    gameplayServiceId: string;
    gameId?: string;
    userId?: string;
}

export enum ServicePort {
    TG = 3000,
    Gameplay = 3001,
    GameplayLobby = 3002,
    Gateway = 3003,
    WsGateway = 3004,
}

export enum ServiceName {
    Gameplay = 'GameplayService',
    GameplayLobby = 'GameplayLobbyService',
    Gateway = 'GatewayService',
    WsGateway = 'WsGatewayService',
}

const NatsUrl = 'nats://0.0.0.0:4222';
// const NatsUrl = 'nats://nats:4222';

export default NatsUrl;