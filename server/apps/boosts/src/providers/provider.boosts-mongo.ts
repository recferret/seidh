import { BoostSchema } from '@lib/seidh-common/schemas/boost/schema.boost';
import { BoostTransactionSchema } from '@lib/seidh-common/schemas/boost/schema.boost-transaction';
import { UserSchema } from '@lib/seidh-common/schemas/user/schema.user';
import { Mongoose } from 'mongoose';

export const ProviderBoostsMongo = [
  {
    provide: 'UserModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('User', UserSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'BoostModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('Boost', BoostSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'BoostTransactionModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('BoostTransaction', BoostTransactionSchema),
    inject: ['DATABASE_CONNECTION'],
  },
];
