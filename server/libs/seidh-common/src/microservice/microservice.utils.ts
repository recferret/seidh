import { Logger } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';

import { catchError, firstValueFrom, map, of } from 'rxjs';

export class MicroserviceWrapper {
  constructor(private clientProxy: ClientProxy) {}

  public async request<Req, Res>(pattern: string, request: Req) {
    const result = await firstValueFrom(
      this.clientProxy.send(pattern, request).pipe(
        map((response: Res) => response),
        catchError((err) => {
          Logger.error(err);
          return of({
            success: false,
            errorCode: 1,
          } as Res);
        }),
      ),
    );
    return result;
  }
}
