import { IsNumber, IsObject, IsOptional, IsString } from 'class-validator';

import { VkLaunchParams } from '@lib/seidh-common/types/types.vk';

export class AuthTgRequestDto {
  @IsString()
  telegramInitData: string;
}

export class AuthVkRequestDto {
  @IsObject()
  vkLaunchParams: VkLaunchParams;

  @IsOptional()
  @IsString()
  first_name: string;

  @IsOptional()
  @IsString()
  last_name: string;

  @IsOptional()
  @IsNumber()
  id: number;
}

export class AuthSimpleRequestDto {
  @IsString()
  login: string;
}

export class AuthResponseDto {
  success: boolean;
  authToken?: string;
}
