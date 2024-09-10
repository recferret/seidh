import { BoostBody } from '@app/seidh-common/dto/boost/boost.get.boosts.msg';

export class GetBoostsResponseDTO {
  success: boolean;
  message?: string;
  boosts?: BoostBody[];
}
