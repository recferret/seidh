import { Job } from 'bull';

import { Process, Processor } from '@nestjs/bull';
import { Logger } from '@nestjs/common';

@Processor('gamelog')
export class GameplayWorkerConsumer {
  @Process()
  transcode(job: Job) {
    Logger.log(job);
    return {};
  }
}
