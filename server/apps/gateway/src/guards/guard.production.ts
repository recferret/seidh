import {
  Injectable,
  CanActivate,
  ExecutionContext,
} from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class ProductionGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();
    if (
      process.env.NODE_ENV == 'production' &&
      !request.body.hasOwnProperty('telegramInitData')
    ) {
      return false;
    }
    return true;
  }
}
