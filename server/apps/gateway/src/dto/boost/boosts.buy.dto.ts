import { BoostBody } from '@lib/seidh-common/dto/boosts/boosts.get.msg';

export class BoostsBuyRequestDto {
  boostId: string;
}

export class BoostsBuyResponseDto {
  success: boolean;
  boosts?: BoostBody[];
}
