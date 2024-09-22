import { UserBody } from '@app/seidh-common/dto/users/users.get.user.msg';

export class UserGetUserResponseDto {
  success: boolean;
  user?: UserBody;
}
