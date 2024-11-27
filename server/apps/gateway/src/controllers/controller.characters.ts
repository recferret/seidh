import { Body, Controller, Get, Session, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../guards/guard.auth';
import { IUserSession } from './interfaces';
import { ServiceCharacters } from '../services/service.characters';
import { CharacterServiceLevelUpRequestDto } from '../dto/character/character.level-up.dto';

@Controller('characters')
export class ControllerCharacters {
  constructor(private readonly serviceCharacters: ServiceCharacters) {}

  @Get('by-user')
  @UseGuards(AuthGuard)
  getByUser(@Session() session: IUserSession) {}

  @Get('default-params')
  @UseGuards(AuthGuard)
  getDefaultParams() {
    return this.serviceCharacters.getDefaultParams();
  }

  @Get('level-up')
  @UseGuards(AuthGuard)
  levelUp(
    @Session() session: IUserSession,
    @Body() req: CharacterServiceLevelUpRequestDto,
  ) {}
}
