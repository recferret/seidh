import { Injectable } from '@nestjs/common';

import { MicroserviceUsers } from '@lib/seidh-common/microservice/microservice.users';

import { AuthResponseDto, AuthSimpleRequestDto, AuthTgRequestDto, AuthVkRequestDto } from '../dto/auth/auth.dto';
import { UserGetUserResponseDto } from '../dto/user/user.get.user.dto';

@Injectable()
export class ServiceUsers {
  constructor(private microserviceUsers: MicroserviceUsers) {}

  async tgAuth(req: AuthTgRequestDto) {
    const result = await this.microserviceUsers.tgAuth({
      telegramInitData: req.telegramInitData,
      // referrerId: req.referrerId,
    });

    const response: AuthResponseDto = {
      success: result.success,
      authToken: result.authToken,
    };
    return response;
  }

  async vkAuth(req: AuthVkRequestDto) {
    const result = await this.microserviceUsers.vkAuth(req);

    const response: AuthResponseDto = {
      success: result.success,
      authToken: result.authToken,
    };
    return response;
  }

  async simpleAuth(req: AuthSimpleRequestDto) {
    const result = await this.microserviceUsers.simpleAuth({
      login: req.login,
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
