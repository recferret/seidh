import { Controller } from '@nestjs/common';
import {
  UsersGetUserPattern,
  UsersGetUserServiceRequest,
} from '@app/seidh-common/dto/users/users.get.user.msg';
import { MessagePattern } from '@nestjs/microservices';
import {
  UsersUpdateGainingsPattern,
  UsersUpdateGainingsServiceMessage,
} from '@app/seidh-common/dto/users/users.update.gainings';
import { ServiceUser } from '../services/service.user';

@Controller()
export class ControllerUser {
  constructor(private readonly serviceUser: ServiceUser) {}

  @MessagePattern(UsersGetUserPattern)
  async getUser(request: UsersGetUserServiceRequest) {
    return this.serviceUser.getUser(request);
  }

  @MessagePattern(UsersUpdateGainingsPattern)
  async updateGainings(message: UsersUpdateGainingsServiceMessage) {
    return this.serviceUser.updateGainings(message);
  }
}
