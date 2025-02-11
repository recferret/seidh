import { CanActivate, ExecutionContext, Injectable, Logger } from '@nestjs/common';

import { Observable } from 'rxjs';

@Injectable()
export class ProductionGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();
    Logger.log(process.env.NODE_ENV);
    return process.env.NODE_ENV == 'production' && request.body.hasOwnProperty('login') ? false : true;
  }
}
