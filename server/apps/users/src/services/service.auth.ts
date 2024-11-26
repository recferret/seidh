import {
  UsersAuthenticateServiceRequest,
  UsersAuthenticateServiceResponse,
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersCheckTokenServiceRequest,
  UsersCheckTokenServiceResponse,
} from '@app/seidh-common/dto/users/users.check.token.msg';

import { User, UserDocument } from '@app/seidh-common/schemas/user/schema.user';
import { Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { ProviderCrypto } from '../providers/provider.crypto';
import { MicroserviceCharacters } from '@app/seidh-common/microservice/microservice.characters';
import { CharacterType } from '@app/seidh-common/dto/types/types.character';

@Injectable()
export class ServiceAuth {
  private readonly botKey = process.env.TG_BOT_KEY;
  private readonly isProd = process.env.NODE_ENV == 'production';

  constructor(
    private jwtService: JwtService,
    private providerCrypto: ProviderCrypto,
    private microserviceCharacter: MicroserviceCharacters,
    @InjectModel(User.name) private userModel: Model<User>,
  ) {}

  async authenticate(request: UsersAuthenticateServiceRequest) {
    const response: UsersAuthenticateServiceResponse = {
      success: false,
    };

    try {
      let existingUser: UserDocument;
      let telegramId: string;
      let telegramName: string;
      let telegramPremium: boolean;
      let login: string;

      if (this.isProd) {
        const telegramParseResult = this.providerCrypto.parseTelegramInitData(
          this.botKey,
          request.telegramInitData,
        );

        if (telegramParseResult.correctHash) {
          telegramId = telegramParseResult.userInfo.id;

          if (telegramParseResult.userInfo.username) {
            telegramName = telegramParseResult.userInfo.username;
          } else {
            telegramName = telegramParseResult.userInfo.first_name;

            if (telegramParseResult.userInfo.last_name) {
              telegramName += ' ' + telegramParseResult.userInfo.last_name;
            }
          }

          telegramPremium = telegramParseResult.userInfo.is_premium;

          response.success = true;

          existingUser = await this.userModel.findOne({ telegramId });
        } else {
          return response;
        }
      } else {
        login = request.login;
        existingUser = await this.userModel.findOne({ login });
      }

      if (existingUser) {
        response.authToken = await this.jwtService.signAsync({
          userId: existingUser.id,
          telegramId,
          login,
        });

        existingUser.authToken = response.authToken;
        existingUser.telegramName = telegramName;
        await existingUser.save();
      } else {
        const rsaKeyPair = await this.providerCrypto.generateNewRsaKeyPair();

        const character = await this.microserviceCharacter.create({
          characterType: CharacterType.RagnarLoh,
        });

        // const newCharacter = await this.characterModel.create({
        //   type: CharacterType.RagnarLoh,
        //   movement: {
        //     runSpeed: 20,
        //     walkSpeed: 10,
        //   },
        //   actionMain: {
        //     damage: 10,
        //   },
        // });

        const newUser = new this.userModel({
          telegramId,
          telegramName,
          telegramPremium,
          login,
          characters: [character.characterId],
          privateRsaKey: rsaKeyPair.privateKey,
        });
        const authToken = await this.jwtService.signAsync({
          userId: newUser.id,
          telegramId,
          login,
        });
        newUser.authToken = authToken;

        await newUser.save();

        if (request.referrerId) {
          await this.referralCalculation({
            referrerId: request.referrerId,
            telegramId,
            login,
            newUser,
          });
        }

        response.authToken = authToken;
        response.publicRsaKey = rsaKeyPair.publicKey;
      }

      response.success = true;
    } catch (error) {
      Logger.log({
        msg: 'authenticate error',
        request,
        error,
      });
    }

    return response;
  }

  async checkToken(request: UsersCheckTokenServiceRequest) {
    const hasUser = await this.userModel.findOne({
      authToken: request.authToken,
    });
    const response: UsersCheckTokenServiceResponse = {
      success: hasUser !== undefined,
    };
    return response;
  }

  private async referralCalculation({
    referrerId,
    telegramId,
    login,
    newUser,
  }) {
    // const referrer = await this.userModel.findById(referrerId);
    // const notTheSameUser = this.isProd
    //   ? referrer.telegramId != telegramId
    //   : referrer.login != login;

    // if (referrer && notTheSameUser) {
    //   const { referrer: updatedReferrer, newUser: updatedNewUser } =
    //     await firstValueFrom(
    //       this.referralService.send(ReferralUpdateReferrerPattern, {
    //         referrer,
    //         newUser,
    //       }),
    //     );
    //   Object.keys(updatedReferrer).forEach((key) => {
    //     referrer[key] = updatedReferrer[key];
    //   });
    //   await Promise.all([
    //     referrer.save(),
    //     this.userModel.findByIdAndUpdate(newUser._id, {
    //       virtualTokenBalance: updatedNewUser.virtualTokenBalance,
    //     }),
    //   ]);
    // }
  }
}
