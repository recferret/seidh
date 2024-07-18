export const BoostsGetPattern = 'boosts.get';

export interface BoostBody {
    id: string;
    order: number;
    name: string;
    description: string;
    price: number;
    accquired: boolean;
}

export interface BoostsGetMessageRequest {
    userId: string;
}

export interface BoostsGetMessageResponse {
    success: boolean;
    message?: string;
    boosts?: BoostBody[];
}