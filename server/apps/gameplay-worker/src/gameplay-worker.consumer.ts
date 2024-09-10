import { Process, Processor } from '@nestjs/bull';
import { Logger } from '@nestjs/common';
import { Job } from 'bull';

@Processor('gamelog')
export class GameplayWorkerConsumer {
  @Process()
  transcode(job: Job) {
    Logger.log(job);
    return {};
  }
}
