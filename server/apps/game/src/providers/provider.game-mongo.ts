import { GameSchema } from '@lib/seidh-common/schemas/game/schema.game';
import { GameConfigSchema } from '@lib/seidh-common/schemas/game/schema.game-config';
import { Mongoose } from 'mongoose';

export const ProviderGameMongo = [
  {
    provide: 'GameModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('Game', GameSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'GameConfigModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('GameConfig', GameConfigSchema),
    inject: ['DATABASE_CONNECTION'],
  },
];
