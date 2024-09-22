import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  UsersGetFriendsServiceRequest,
  UsersGetFriendsServiceResponse,
  UsersGetFriendsPattern,
} from '../dto/users/users.get.friends.msg';

@Injectable()
export class MicroserviceFriends {
  constructor(@Inject(ServiceName.Users) private usersService: ClientProxy) {}

  async getFriends(request: UsersGetFriendsServiceRequest) {
    const response: UsersGetFriendsServiceResponse = await firstValueFrom(
      this.usersService.send(UsersGetFriendsPattern, request),
    );
    return response;
  }
}
