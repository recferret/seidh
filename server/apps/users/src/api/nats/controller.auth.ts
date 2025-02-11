import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { ServiceAuth } from '../../services/service.auth';

import {
  UsersServiceSimpleAuthPattern,
  UsersServiceSimpleAuthRequest,
  UsersServiceTgAuthPattern,
  UsersServiceTgAuthRequest,
  UsersServiceVkAuthPattern,
  UsersServiceVkAuthRequest,
} from '@lib/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersServiceCheckTokenPattern,
  UsersServiceCheckTokenRequest,
} from '@lib/seidh-common/dto/users/users.check-token.msg';

@Controller()
export class ControllerAuth {
  constructor(private readonly serviceAuth: ServiceAuth) {}

  @MessagePattern(UsersServiceTgAuthPattern)
  async tgAuth(request: UsersServiceTgAuthRequest) {
    return this.serviceAuth.tgAuth(request);
  }

  @MessagePattern(UsersServiceVkAuthPattern)
  async vkAuth(request: UsersServiceVkAuthRequest) {
    return this.serviceAuth.vkAuth(request);
  }

  @MessagePattern(UsersServiceSimpleAuthPattern)
  async simpleAuth(request: UsersServiceSimpleAuthRequest) {
    return this.serviceAuth.simpleAuth(request);
  }

  @MessagePattern(UsersServiceCheckTokenPattern)
  async checkAuthToken(request: UsersServiceCheckTokenRequest) {
    return this.serviceAuth.checkToken(request);
  }
}
