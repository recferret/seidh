import * as mongoose from 'mongoose';

export const MongoProviders = [
  {
    provide: 'DATABASE_CONNECTION',
    useFactory: (): Promise<typeof mongoose> =>
      mongoose.connect(
        // process.env.NODE_ENV == 'production'
        'mongodb://ferretrec:khlhasdg972^&*TFGy@mongodb:27017',
        // 'mongodb://localhost:27017',
        { dbName: 'seidh' },
      ),
  },
];
