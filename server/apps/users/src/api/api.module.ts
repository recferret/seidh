import { Module } from '@nestjs/common';

import { ControllerAuth } from './nats/controller.auth';
import { ControllerFriends } from './nats/controller.friends';
import { ControllerUser } from './nats/controller.user';

@Module({
  imports: [],
  controllers: [ControllerAuth, ControllerFriends, ControllerUser],
  providers: [],
})
export class ApiModule {}
