import { MicroserviceUser } from '@app/seidh-common/microservice/microservice.user';
import { Injectable } from '@nestjs/common';
import { UserGetUserResponseDto } from '../dto/user/user.get.user.dto';

@Injectable()
export class ServiceUser {
  constructor(private microserviceUser: MicroserviceUser) {}

  async getUser(userId: string) {
    const response = await this.microserviceUser.getUser({
      userId,
    });
    const responseDto: UserGetUserResponseDto = {
      success: response.success,
      user: response.user,
    };
    return responseDto;
  }
}
