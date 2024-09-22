import { BoostBody } from '@app/seidh-common/dto/boost/boost.get.boosts.msg';

export class BoostsBuyRequestDto {
  boostId: string;
}

export class BoostsBuyResponseDto {
  success: boolean;
  boosts?: BoostBody[];
}
