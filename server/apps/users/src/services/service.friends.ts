import { User } from '@lib/seidh-common/schemas/user/schema.user';
import { Model } from 'mongoose';

import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';

import {
  UsersServiceGetFriendsRequest,
  UsersServiceGetFriendsResponse,
} from '@lib/seidh-common/dto/users/users.get-friends.msg';

@Injectable()
export class ServiceFriends {
  constructor(@InjectModel(User.name) private userModel: Model<User>) {}

  async getFriends(request: UsersServiceGetFriendsRequest) {
    const response: UsersServiceGetFriendsResponse = {
      success: false,
    };
    const user = await this.userModel.findById(request.userId).populate(['friendsInvited']);
    if (user) {
      response.success = true;
      response.friends = (
        user.friendsInvited as unknown as {
          id: string;
          email: string;
          totalReferralRewards: number;
          online: boolean;
        }[]
      ).map((friend) => ({
        userId: friend.id,
        telegramName: friend.email,
        referralReward: friend.totalReferralRewards,
        online: friend.online,
        // playing: boolean;
        // possibleToJoinGame: boolean;
      }));
      response.friendsInvited = user.friendsInvited.length;
      response.coins = user.coins;
    } else {
      Logger.error(`getFriends. user ${request.userId} not found`);
    }

    return response;
  }
}
