import { CharacterSchema } from '@lib/seidh-common/schemas/character/schema.character';
import { GameSchema } from '@lib/seidh-common/schemas/game/schema.game';
import { UserBalanceTransactionSchema } from '@lib/seidh-common/schemas/user/schema.balance.transaction';
import { UserSchema } from '@lib/seidh-common/schemas/user/schema.user';
import { Mongoose } from 'mongoose';

export const ProviderUsersMongo = [
  {
    provide: 'UserModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('User', UserSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'CharacterModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('Character', CharacterSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'GameModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('Game', GameSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'UserBalanceTransactionModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('UserBalanceTransaction', UserBalanceTransactionSchema),
    inject: ['DATABASE_CONNECTION'],
  },
];
