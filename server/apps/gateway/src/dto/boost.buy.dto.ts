import { BoostBody } from '@app/seidh-common/dto/boost/boost.get.boosts.msg';

export class BuyBoostRequestDTO {
  boostId: string;
}

export class BuyBoostResponseDTO {
  success: boolean;
  boosts?: BoostBody[];
}
