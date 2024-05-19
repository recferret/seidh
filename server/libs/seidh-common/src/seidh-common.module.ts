import { Module } from '@nestjs/common';
import { SeidhCommonService } from './seidh-common.service';

@Module({
  providers: [SeidhCommonService],
  exports: [SeidhCommonService],
})
export class SeidhCommonModule {}
