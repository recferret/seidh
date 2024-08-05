import { BoostBody } from '@app/seidh-common/dto/boost/boost.get.boosts.msg';

export class GetBoostsResponse {
  success: boolean;
  boosts?: BoostBody[];
}
