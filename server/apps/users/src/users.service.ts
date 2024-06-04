import { 
  UserCharacterStruct, 
  UsersAuthenticateMessageRequest, 
  UsersAuthenticateMessageResponse 
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import { Character, CharacterType } from '@app/seidh-common/schemas/schema.character';
import { User } from '@app/seidh-common/schemas/schema.user';
import { Injectable, OnModuleInit } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

const crypto = require('crypto');

@Injectable()
export class UsersService implements OnModuleInit {

  private readonly botKey = '7109468529:AAHvO4toPIdlBVgEJkDc8Yjozx1uXsM4QV8';

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Character.name) private characterModel: Model<Character>,
    private jwtService: JwtService
  ) {}

  async onModuleInit() {
    // const xxx = this.parseTelegramInitData('query_id=AAEFln8BAAAAAAWWfwH0UjCO&user=%7B%22id%22%3A25138693%2C%22first_name%22%3A%22Andrey%22%2C%22last_name%22%3A%22Sokolov%22%2C%22username%22%3A%22FerretRec%22%2C%22language_code%22%3A%22ru%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1716481616&hash=6c178e00d76e065a0eb274d65d02e637dbc209151b5c6538738d8c7d649c9e01');
    // console.log(xxx);
    // await this.authenticate({
    //   telegramInitData: 'query_id=AAEFln8BAAAAAAWWfwH0UjCO&user=%7B%22id%22%3A25138693%2C%22first_name%22%3A%22Andrey%22%2C%22last_name%22%3A%22Sokolov%22%2C%22username%22%3A%22FerretRec%22%2C%22language_code%22%3A%22ru%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1716481616&hash=6c178e00d76e065a0eb274d65d02e637dbc209151b5c6538738d8c7d649c9e01'
    // });
  }

  async authenticate(message: UsersAuthenticateMessageRequest)  {
    const response: UsersAuthenticateMessageResponse = {
      success: false,
    };
    const telegramParseResult = this.parseTelegramInitData(message.telegramInitData);

    if (telegramParseResult.correctHash) {
      function dbCharacterToStruct(c: any) {
        const character = c as Character;
        const characterStruct:UserCharacterStruct = {
          id: character.id,
          active: character.active,
          type: character.type,
          levelCurrent: character.levelCurrent,
          levelMax: character.levelMax,
          expCurrent: character.expCurrent,
          expTillNewLevel: character.expTillNewLevel,
          health: character.health,
          movement: {
            runSpeed: character.movement.runSpeed, 
            walkSpeed: character.movement.walkSpeed,
          },
          actionMain: {
            damage: character.actionMain.damage,
          }
        };
        return characterStruct;
      }

      response.success = true;
      response.telegramName = telegramParseResult.userInfo.username;

      const existingUser = await this.userModel.findOne({telegramId: telegramParseResult.userInfo.id}).populate(['characters']);

      if (existingUser) {
        response.kills = existingUser.kills;
        response.tokens = existingUser.virtualTokenBalance;
        response.characters = existingUser.characters.map(dbCharacterToStruct);
        response.authToken = await this.jwtService.signAsync({
          internalId: existingUser.id,
          telegramId: telegramParseResult.userInfo.id
        });
      } else {
        const newCharacter = await this.characterModel.create({
          type: CharacterType.Ragnar,
          movement: {
            runSpeed: 20,
            walkSpeed: 10,
          },
          actionMain: {
            damage: 10
          }
        });

        const newUser = await this.userModel.create({
          telegramId: telegramParseResult.userInfo.id,
          telegramName: telegramParseResult.userInfo.username,
          telegramPremium: telegramParseResult.userInfo.is_premium,
          characters: [newCharacter],
        });

        response.kills = newUser.kills;
        response.tokens = newUser.virtualTokenBalance;
        response.characters = newUser.characters.map(dbCharacterToStruct);
        response.authToken = await this.jwtService.signAsync({
          internalId: newUser.id,
          telegramId: telegramParseResult.userInfo.id
        });
      }
    }

    return response;
  }

  async leaderboard() {

  }


  private parseTelegramInitData(telegramInitData: string) {
    const encoded = decodeURIComponent(telegramInitData);
    const secret = crypto.createHmac('sha256', 'WebAppData').update(this.botKey);
    const arr = encoded.split("&");
    const hashIndex = arr.findIndex((str) => str.startsWith("hash="));
    const hash = arr.splice(hashIndex)[0].split("=")[1];

    arr.sort((a, b) => a.localeCompare(b));
    const dataCheckString = arr.join("\n");

    const _hash = crypto
      .createHmac("sha256", secret.digest())
      .update(dataCheckString)
      .digest("hex");

    return {
      correctHash: _hash === hash,
      userInfo: JSON.parse(arr[2].split("=")[1]),
    }
  }
}
