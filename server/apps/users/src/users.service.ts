import {
  UsersAuthenticateMessageRequest,
  UsersAuthenticateMessageResponse,
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import {
  UsersCheckTokenMessageRequest,
  UsersCheckTokenMessageResponse,
} from '@app/seidh-common/dto/users/users.check.token.msg';
import {
  UsersGetFriendsMessageRequest,
  UsersGetFriendsMessageResponse,
} from '@app/seidh-common/dto/users/users.get.friends.msg';
import {
  CharacterBody,
  UserBody,
  UsersGetUserMessageRequest,
  UsersGetUserMessageResponse,
} from '@app/seidh-common/dto/users/users.get.user.msg';
import {
  Character,
  CharacterType,
} from '@app/seidh-common/schemas/schema.character';
import { User, UserDocument } from '@app/seidh-common/schemas/schema.user';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { firstValueFrom } from 'rxjs';
import { ServiceName } from '@app/seidh-common';
import { ClientProxy } from '@nestjs/microservices';
import { ReferralUpdateReferrerPattern } from '@app/seidh-common/dto/referral/referral.update.referrer.msg';

import crypto from 'crypto';

@Injectable()
export class UsersService {
  private readonly botKey = process.env.TG_BOT_KEY;
  private readonly isProd = process.env.NODE_ENV == 'production';

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Character.name) private characterModel: Model<Character>,
    @Inject(ServiceName.Referral) private referralService: ClientProxy,
    private jwtService: JwtService,
  ) {}

  async authenticate(message: UsersAuthenticateMessageRequest) {
    const response: UsersAuthenticateMessageResponse = {
      success: false,
    };

    // function dbCharacterToStruct(c: any) {
    //   const character = c as CharacterDocument;
    //   const characterStruct: UserCharacterStruct = {
    //     id: character.id,
    //     active: character.active,
    //     type: character.type,
    //     levelCurrent: character.levelCurrent,
    //     levelMax: character.levelMax,
    //     expCurrent: character.expCurrent,
    //     expTillNewLevel: character.expTillNewLevel,
    //     health: character.health,
    //     movement: {
    //       runSpeed: character.movement.runSpeed,
    //       walkSpeed: character.movement.walkSpeed,
    //     },
    //     actionMain: {
    //       damage: character.actionMain.damage,
    //     },
    //   };
    //   return characterStruct;
    // }

    let existingUser: UserDocument;
    let telegramId: string;
    let telegramName: string;
    let telegramPremium: boolean;
    let login: string;

    if (this.isProd) {
      const telegramParseResult = this.parseTelegramInitData(
        message.telegramInitData,
      );
      if (telegramParseResult.correctHash) {
        response.success = true;
        response.telegramName = telegramParseResult.userInfo.username;
        telegramId = telegramParseResult.userInfo.id;
        telegramName = telegramParseResult.userInfo.username;
        telegramPremium = telegramParseResult.userInfo.is_premium;
        existingUser = await this.userModel.findOne({ telegramId });
      } else {
        return response;
      }
    } else {
      login = message.login;
      existingUser = await this.userModel.findOne({ login });
    }

    if (existingUser) {
      response.authToken = await this.jwtService.signAsync({
        userId: existingUser.id,
        telegramId,
        login,
      });

      existingUser.authToken = response.authToken;
      await existingUser.save();
    } else {
      const newCharacter = await this.characterModel.create({
        type: CharacterType.RagnarLoh,
        movement: {
          runSpeed: 20,
          walkSpeed: 10,
        },
        actionMain: {
          damage: 10,
        },
      });

      const virtualTokenBalance = 0;

      const newUser = new this.userModel({
        telegramId,
        telegramName,
        telegramPremium,
        login,
        virtualTokenBalance,
        characters: [newCharacter],
      });
      const authToken = await this.jwtService.signAsync({
        userId: newUser.id,
        telegramId,
        login,
      });
      newUser.authToken = authToken;
      await newUser.save();
      if (message.referrerId)
        this.referralCalculation({
          referrerId: message.referrerId,
          telegramId,
          login,
          newUser,
        });

      response.authToken = authToken;
    }

    response.success = true;

    return response;
  }

  async referralCalculation({ referrerId, telegramId, login, newUser }) {
    const referrer = await this.userModel.findById(referrerId);
    const notTheSameUser = this.isProd
      ? referrer.telegramId != telegramId
      : referrer.login != login;

    if (referrer && notTheSameUser) {
      const { referrer: updatedReferrer, newUser: updatedNewUser } =
        await firstValueFrom(
          this.referralService.send(ReferralUpdateReferrerPattern, {
            referrer,
            newUser,
          }),
        );
      Object.keys(updatedReferrer).forEach((key) => {
        referrer[key] = updatedReferrer[key];
      });
      await Promise.all([
        referrer.save(),
        this.userModel.findByIdAndUpdate(newUser._id, {
          virtualTokenBalance: updatedNewUser.virtualTokenBalance,
        }),
      ]);
    }
  }

  async checkToken(message: UsersCheckTokenMessageRequest) {
    const hasUser = await this.userModel.findOne({
      authToken: message.authToken,
    });
    const response: UsersCheckTokenMessageResponse = {
      success: hasUser !== undefined,
    };
    return response;
  }

  async getUser(message: UsersGetUserMessageRequest) {
    const response: UsersGetUserMessageResponse = {
      success: false,
    };

    try {
      const user = await this.userModel
        .findById(message.userId)
        .populate(['characters']);

      const userBody: UserBody = {
        userId: user.id,

        telegramName: user.telegramName,
        telegramPremium: user.telegramPremium,

        virtualTokenBalance: user.virtualTokenBalance,

        characters: user.characters.map((c: any) => {
          const character: CharacterBody = {
            id: c.id,
            type: c.type,
            active: c.active,
            levelCurrent: c.levelCurrent,
            levelMax: c.levelMax,
            expCurrent: c.expCurrent,
            expTillNewLevel: c.expTillNewLevel,
            health: c.health,
            movement: c.movement,
            actionMain: c.actionMain,
          };
          return character;
        }),

        hasExpBoost1: user.hasExpBoost1,
        hasExpBoost2: user.hasExpBoost2,
        hasPotionDropBoost1: user.hasPotionDropBoost1,
        hasPotionDropBoost2: user.hasPotionDropBoost2,
        hasMaxPotionBoost1: user.hasMaxPotionBoost1,
        hasMaxPotionBoost2: user.hasMaxPotionBoost2,
        hasMaxPotionBoost3: user.hasMaxPotionBoost3,
      };

      response.user = userBody;
      response.success = true;
    } catch (e) {
      Logger.error(e);
    }

    return response;
  }

  async getFriends(message: UsersGetFriendsMessageRequest) {
    const response: UsersGetFriendsMessageResponse = {
      success: false,
    };
    const user = await this.userModel
      .findById(message.userId)
      .populate(['friendsInvited']);
    if (user) {
      response.success = true;
      response.friends = (
        user.friendsInvited as unknown as {
          id: string;
          email: string;
          totalReferralRewards: number;
          online: boolean;
        }[]
      ).map((friend) => ({
        userId: friend.id,
        telegramName: friend.email,
        referralReward: friend.totalReferralRewards,
        online: friend.online,
        // playing: boolean;
        // possibleToJoinGame: boolean;
      }));
      response.friendsInvited = user.friendsInvited.length;
      response.virtualTokenBalance = user.virtualTokenBalance;
    }

    return response;
  }

  async leaderboard() {}

  private parseTelegramInitData(telegramInitData: string) {
    const encoded = decodeURIComponent(telegramInitData);

    const secret = crypto
      .createHmac('sha256', 'WebAppData')
      .update(this.botKey);
    const arr = encoded.split('&');
    const hashIndex = arr.findIndex((str) => str.startsWith('hash='));
    const hash = arr.splice(hashIndex)[0].split('=')[1];

    arr.sort((a, b) => a.localeCompare(b));
    const dataCheckString = arr.join('\n');

    const _hash = crypto
      .createHmac('sha256', secret.digest())
      .update(dataCheckString)
      .digest('hex');

    return {
      correctHash: _hash === hash,
      userInfo: JSON.parse(arr[2].split('=')[1]),
    };
  }
}
