import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { ServiceName } from '../seidh-common.internal-protocol';
import { firstValueFrom } from 'rxjs';
import {
  UsersAuthenticateServiceRequest,
  UsersAuthenticateServiceResponse,
  UsersAuthenticatePattern,
} from '../dto/users/users.authenticate.msg';

@Injectable()
export class MicroserviceReferral {
  constructor(
    @Inject(ServiceName.Characters) private charactersService: ClientProxy,
  ) {}

  async authenticate(request: UsersAuthenticateServiceRequest) {
    const response: UsersAuthenticateServiceResponse = await firstValueFrom(
      this.usersService.send(UsersAuthenticatePattern, request),
    );
    return response;
  }
}
