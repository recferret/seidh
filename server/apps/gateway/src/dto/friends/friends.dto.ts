import { Friend } from '@app/seidh-common/dto/users/users.get.friends.msg';

export class FriendsGetResponseDto {
  success: boolean;
  friends?: Friend[];
  friendsInvited: number;
  virtualTokenBalance: number;
}
