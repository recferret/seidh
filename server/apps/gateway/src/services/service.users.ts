import { MicroserviceUsers } from '@app/seidh-common/microservice/microservice.users';
import { Injectable } from '@nestjs/common';
import { UserGetUserResponseDto } from '../dto/user/user.get.user.dto';
import { AuthRequestDto, AuthResponseDto } from '../dto/auth/auth.dto';

@Injectable()
export class ServiceUsers {
  constructor(private microserviceUsers: MicroserviceUsers) {}

  async authenticate(req: AuthRequestDto) {
    const result = await this.microserviceUsers.authenticate({
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

  async getUser(userId: string) {
    const response = await this.microserviceUsers.getUser({
      userId,
    });
    const responseDto: UserGetUserResponseDto = {
      success: response.success,
      user: response.user,
    };
    return responseDto;
  }
}
