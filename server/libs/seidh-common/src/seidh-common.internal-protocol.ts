export interface WsGameEvent {
    broadcast: boolean;
    gameplayServiceId: string;
    gameId?: string;
    userId?: string;
}

export enum ServicePort {
    Gameplay = 3000,
    GameplayLobby = 3001,
    Gateway = 3002,
    WsGateway = 3003,
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