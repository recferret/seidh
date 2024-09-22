import { Injectable } from '@nestjs/common';
import { AuthRequestDto, AuthResponseDto } from '../dto/auth/auth.dto';
import { MicroserviceAuth } from '@app/seidh-common/microservice/microservice.auth';

@Injectable()
export class ServiceAuth {
  constructor(private microserviceAuth: MicroserviceAuth) {}

  async authenticate(req: AuthRequestDto) {
    const result = await this.microserviceAuth.authenticate({
      telegramInitData: req.telegramInitData,
      login: req.login,
      referrerId: req.referrerId,
    });

    const response: AuthResponseDto = {
      success: result.success,
      authToken: result.authToken,
    };
    return response;
  }
}
