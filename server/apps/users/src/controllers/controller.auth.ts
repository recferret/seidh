import { Controller } from '@nestjs/common';
import {
  UsersAuthenticatePattern,
  UsersAuthenticateServiceRequest,
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersCheckTokenPattern,
  UsersCheckTokenServiceRequest,
} from '@app/seidh-common/dto/users/users.check.token.msg';
import { MessagePattern } from '@nestjs/microservices';
import { ServiceAuth } from '../services/service.auth';

@Controller()
export class ControllerAuth {
  constructor(private readonly serviceAuth: ServiceAuth) {}

  @MessagePattern(UsersAuthenticatePattern)
  async authenticate(request: UsersAuthenticateServiceRequest) {
    return this.serviceAuth.authenticate(request);
  }

  @MessagePattern(UsersCheckTokenPattern)
  async checkAuthToken(request: UsersCheckTokenServiceRequest) {
    return this.serviceAuth.checkToken(request);
  }
}
