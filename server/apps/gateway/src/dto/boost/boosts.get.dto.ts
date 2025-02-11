import { BoostBody } from '@lib/seidh-common/dto/boosts/boosts.get.msg';

export class BoostsGetResponseDto {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
