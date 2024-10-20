import { Injectable } from '@nestjs/common';
import { FriendsGetResponseDto } from '../dto/friends/friends.dto';
import { MicroserviceFriends } from '@app/seidh-common/microservice/microservice.friends';

@Injectable()
export class ServiceFriends {
  constructor(private microserviceFriends: MicroserviceFriends) {}

  async getFriends(userId: string) {
    const result = await this.microserviceFriends.getFriends({
      userId,
    });
    const response: FriendsGetResponseDto = {
      success: result.success,
      friends: result.friends,
      friendsInvited: result.friendsInvited,
      coins: result.coins,
    };
    return response;
  }
}
