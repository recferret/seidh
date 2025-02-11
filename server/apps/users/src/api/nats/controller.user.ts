import { Controller } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';

import { ServiceUser } from '../../services/service.user';

import { UsersServiceGetUserPattern, UsersServiceGetUserRequest } from '@lib/seidh-common/dto/users/users.get-user.msg';
import {
  UsersServiceUpdateBalancePattern,
  UsersServiceUpdateBalanceRequest,
} from '@lib/seidh-common/dto/users/users.update-balance.msg';
import {
  UsersServiceUpdateKillsPattern,
  UsersServiceUpdateKillsRequest,
} from '@lib/seidh-common/dto/users/users.update-kills.msg';

@Controller()
export class ControllerUser {
  constructor(private readonly serviceUser: ServiceUser) {}

  @MessagePattern(UsersServiceGetUserPattern)
  async getUser(request: UsersServiceGetUserRequest) {
    return this.serviceUser.getUser(request);
  }

  @MessagePattern(UsersServiceUpdateKillsPattern)
  async updateKills(request: UsersServiceUpdateKillsRequest) {
    return this.serviceUser.updateKills(request);
  }

  @MessagePattern(UsersServiceUpdateBalancePattern)
  async updateBalance(request: UsersServiceUpdateBalanceRequest) {
    return this.serviceUser.updateBalance(request);
  }
}
