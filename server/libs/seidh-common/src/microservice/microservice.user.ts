import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  UsersGetUserServiceRequest,
  UsersGetUserServiceResponse,
  UsersGetUserPattern,
} from '../dto/users/users.get.user.msg';
import {
  UsersUpdateGainingsServiceMessage,
  UsersUpdateGainingsPattern,
} from '../dto/users/users.update.gainings';

@Injectable()
export class MicroserviceUser {
  constructor(@Inject(ServiceName.Users) private usersService: ClientProxy) {}

  async getUser(request: UsersGetUserServiceRequest) {
    const result: UsersGetUserServiceResponse = await firstValueFrom(
      this.usersService.send(UsersGetUserPattern, request),
    );
    return result;
  }

  async updateGainings(message: UsersUpdateGainingsServiceMessage) {
    this.usersService.emit(UsersUpdateGainingsPattern, message);
  }
}
