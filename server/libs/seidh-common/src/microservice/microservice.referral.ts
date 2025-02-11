import { Inject, Injectable } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

// import { firstValueFrom } from 'rxjs';
// import {
//   UsersServiceAuthenticatePattern,
//   UsersServiceAuthenticateRequest,
//   UsersServiceAuthenticateResponse,
// } from '../dto/users/users.authenticate.msg';
import { ServiceName } from '../seidh-common.internal-protocol';

@Injectable()
export class MicroserviceReferral {
  constructor(@Inject(ServiceName.Characters) private charactersService: ClientProxy) {}

  // async authenticate(request: UsersAuthenticateServiceRequest) {
  //   const response: UsersAuthenticateServiceResponse = await firstValueFrom(
  //     this.usersService.send(UsersServiceAuthenticatePattern, request),
  //   );
  //   return response;
  // }
}
