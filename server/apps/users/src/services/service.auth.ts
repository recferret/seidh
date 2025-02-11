import { User, UserDocument } from '@lib/seidh-common/schemas/user/schema.user';
import { Model, Types } from 'mongoose';

import { Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';

import { ProviderCrypto } from '../providers/provider.crypto';

import { MicroserviceCharacters } from '@lib/seidh-common/microservice/microservice.characters';

import {
  UsersServiceAuthenticateResponse,
  UsersServiceSimpleAuthRequest,
  UsersServiceTgAuthRequest,
  UsersServiceVkAuthRequest,
} from '@lib/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersServiceCheckTokenRequest,
  UsersServiceCheckTokenResponse,
} from '@lib/seidh-common/dto/users/users.check-token.msg';

import { CharacterType } from '@lib/seidh-common/types/types.character';
import { Platform } from '@lib/seidh-common/types/types.user';

@Injectable()
export class ServiceAuth {
  private readonly tgBotKey = process.env.TG_BOT_KEY;
  private readonly vkAppKey = process.env.VK_APP_KEY;

  constructor(
    private jwtService: JwtService,
    private providerCrypto: ProviderCrypto,
    private microserviceCharacter: MicroserviceCharacters,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}

  async tgAuth(request: UsersServiceTgAuthRequest) {
    const response: UsersServiceAuthenticateResponse = {
      success: false,
    };

    try {
      const telegramParseResult = await this.providerCrypto.parseTelegramInitData(
        this.tgBotKey,
        request.telegramInitData,
      );

      let existingUser = await this.userModel.findOne({ telegramId: telegramParseResult.user.id });

      if (!existingUser) {
        const telegramName = telegramParseResult.user.username;

        existingUser = await this.createAndReturnUser(telegramName, Platform.TG);
        existingUser = await this.attachUserTgAndReturn(
          existingUser,
          telegramParseResult.user.id,
          telegramParseResult.user.is_premium,
        );
      }

      const authToken = await this.refreshAndGetAuthToken(existingUser);
      response.success = true;
      response.authToken = authToken;
    } catch (e) {
      Logger.error(
        {
          request,
        },
        e,
      );
    }

    return response;
  }

  async vkAuth(request: UsersServiceVkAuthRequest) {
    const response: UsersServiceAuthenticateResponse = {
      success: false,
    };

    try {
      const vkVerified = this.providerCrypto.verifyVkLaunchParams(this.vkAppKey, request.vkLaunchParams);

      let existingUser = await this.userModel.findOne({ vkId: request.vkLaunchParams.vk_user_id });

      if (!existingUser) {
        existingUser = await this.createAndReturnUser(request.first_name + ' ' + request.last_name, Platform.VK);
        existingUser = await this.attachUserVkAndReturn(existingUser, request.vkLaunchParams.vk_user_id);
      }

      const authToken = await this.refreshAndGetAuthToken(existingUser);
      response.success = true;
      response.authToken = authToken;
    } catch (e) {
      Logger.error(
        {
          request,
        },
        e,
      );
    }

    return response;
  }

  async simpleAuth(request: UsersServiceSimpleAuthRequest) {
    const response: UsersServiceAuthenticateResponse = {
      success: false,
    };

    try {
      let existingUser = await this.userModel.findOne({ userName: request.login });

      if (!existingUser) {
        existingUser = await this.createAndReturnUser(request.login, Platform.NONE);
      }
      const authToken = await this.refreshAndGetAuthToken(existingUser);
      response.success = true;
      response.authToken = authToken;
    } catch (e) {
      Logger.error(
        {
          request,
        },
        e,
      );
    }

    return response;
  }

  async checkToken(request: UsersServiceCheckTokenRequest) {
    const hasUser = await this.userModel.findOne({
      authToken: request.authToken,
    });
    const response: UsersServiceCheckTokenResponse = {
      success: hasUser !== undefined,
    };
    return response;
  }

  private async createAndReturnUser(userName: string, platform: Platform) {
    const rsaKeyPair = await this.providerCrypto.generateNewRsaKeyPair();
    const character = await this.microserviceCharacter.create({
      characterType: CharacterType.RagnarLoh,
    });

    if (!character || !character.success) {
      throw new Error('Unable to creare character');
    }

    const characterId = new Types.ObjectId(character.characterId);
    const newUser = new this.userModel({
      userName,
      activeCharacter: characterId,
      characters: [characterId],
      privateRsaKey: rsaKeyPair.privateKey,
      platform,
    });
    return await newUser.save();
  }

  private async attachUserTgAndReturn(existingUser: UserDocument, telegramId: number, telegramPremium: boolean) {
    existingUser.tgId = telegramId;
    existingUser.tgPremium = telegramPremium;
    return await existingUser.save();
  }

  private async attachUserVkAndReturn(existingUser: UserDocument, vkId: number) {
    existingUser.vkId = vkId;
    return await existingUser.save();
  }

  private async refreshAndGetAuthToken(existingUser: UserDocument) {
    const jwtObject = {
      userId: existingUser.id,
      userName: existingUser.userName,
    };

    switch (existingUser.platform) {
      case Platform.TG:
        jwtObject['telegramId'] = existingUser.tgId;
      case Platform.VK:
        jwtObject['vkId'] = existingUser.vkId;
    }

    existingUser.authToken = await this.jwtService.signAsync(jwtObject);
    await existingUser.save();

    return existingUser.authToken;
  }
}
