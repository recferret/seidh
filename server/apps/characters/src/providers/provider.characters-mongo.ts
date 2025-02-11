import { AddExpTransactionSchema } from '@lib/seidh-common/schemas/character/schema.add-exp-transaction';
import { CharacterSchema } from '@lib/seidh-common/schemas/character/schema.character';
import { CharacterParamsSchema } from '@lib/seidh-common/schemas/character/schema.character-params';
import { ExpSettingsSchema } from '@lib/seidh-common/schemas/character/schema.exp-settings';
import { LevelUpTransactionSchema } from '@lib/seidh-common/schemas/character/schema.level-up-transaction';
import { LevelingSettingsSchema } from '@lib/seidh-common/schemas/character/schema.leveling-settings';
import { UserSchema } from '@lib/seidh-common/schemas/user/schema.user';
import { Mongoose } from 'mongoose';

export const ProviderCharactersMongo = [
  {
    provide: 'CharacterParamsModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('CharacterParams', CharacterParamsSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'CharacterModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('Character', CharacterSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'ExpSettingsModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('ExpSettings', ExpSettingsSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'LevelingSettingsModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('LevelingSettings', LevelingSettingsSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'AddExpTransactionModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('AddExpTransaction', AddExpTransactionSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'LevelUpTransactionModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('LevelUpTransaction', LevelUpTransactionSchema),
    inject: ['DATABASE_CONNECTION'],
  },
  {
    provide: 'UserModel',
    useFactory: (mongoose: Mongoose) => mongoose.model('User', UserSchema),
    inject: ['DATABASE_CONNECTION'],
  },
];
