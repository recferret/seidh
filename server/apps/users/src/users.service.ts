import { 
  UserCharacterStruct, 
  UsersAuthenticateMessageRequest, 
  UsersAuthenticateMessageResponse 
} from '@app/seidh-common/dto/users/users.authenticate.msg';
import { UsersCheckTokenMessageRequest, UsersCheckTokenMessageResponse } from '@app/seidh-common/dto/users/users.check.token.msg';
import { UsersGetFriendsMessageRequest, UsersGetFriendsMessageResponse } from '@app/seidh-common/dto/users/users.get.friends.msg';
import { CharacterBody, UserBody, UsersGetUserMessageRequest, UsersGetUserMessageResponse } from '@app/seidh-common/dto/users/users.get.user.msg';
import { Character, CharacterDocument, CharacterType } from '@app/seidh-common/schemas/schema.character';
import { User, UserDocument } from '@app/seidh-common/schemas/schema.user';
import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

const crypto = require('crypto');

@Injectable()
export class UsersService {

  private readonly botKey = process.env.TG_BOT_KEY;
  private readonly isProd = process.env.NODE_ENV == 'production';

  private readonly referrerPremiumRewardTokens = 1000;
  private readonly referrerNoPremiumRewardTokens = 200;
  private readonly referralPremiumRewardTokens = 200;
  private readonly referralNoPremiumRewardTokens = 50;

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Character.name) private characterModel: Model<Character>,
    private jwtService: JwtService
  ) {
  }

  async authenticate(message: UsersAuthenticateMessageRequest)  {
    const response: UsersAuthenticateMessageResponse = {
      success: false,
    };

    function dbCharacterToStruct(c: any) {
      const character = c as CharacterDocument;
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

    let existingUser: UserDocument;
    let telegramId: string;
    let telegramName: string;
    let telegramPremium: boolean;
    let email: string;

    if (this.isProd) {
      const telegramParseResult = this.parseTelegramInitData(message.telegramInitData);
      if (telegramParseResult.correctHash) {
        response.success = true;
        response.telegramName = telegramParseResult.userInfo.username;
        telegramId = telegramParseResult.userInfo.id;
        telegramName = telegramParseResult.userInfo.username;
        telegramPremium = telegramParseResult.userInfo.is_premium;
        existingUser = await this.userModel.findOne({telegramId}).populate(['characters']);
      } else {
        return response;
      }
    } else {
      email = message.email;
      existingUser = await this.userModel.findOne({email}).populate(['characters']);
    }

    if (existingUser) {
      response.success = true;
      response.userId = existingUser.id;
      response.kills = existingUser.kills;
      response.tokens = existingUser.virtualTokenBalance;
      response.characters = existingUser.characters.map(dbCharacterToStruct);
      response.authToken = await this.jwtService.signAsync({
        userId: existingUser.id,
        telegramId,
        email
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
          damage: 10
        }
      });

      let virtualTokenBalance = 0;

      const newUser = new this.userModel({
        telegramId,
        telegramName,
        telegramPremium,
        email,
        virtualTokenBalance,
        characters: [newCharacter]
      });

      // TODO move to referral service
      if (message.referrerId) {
        const referrer = await this.userModel.findById(message.referrerId);
        // Referrer exists and referrer is not the same user.
        const notTheSameUser = this.isProd ? 
          referrer.telegramId != telegramId :
          referrer.email != email;

        if (referrer && notTheSameUser) {
          referrer.friendsInvited.push(newUser._id);

          if (this.isProd) {
            // Give some bonus to the referrer
            referrer.virtualTokenBalance += telegramPremium ? 
              this.referrerPremiumRewardTokens : this.referrerNoPremiumRewardTokens;

            // Give some bonus to the referral
            newUser.virtualTokenBalance = telegramPremium ? 
              this.referralPremiumRewardTokens : this.referralNoPremiumRewardTokens;
          } else {
            // Give some bonus to the referrer
            referrer.virtualTokenBalance += this.referrerNoPremiumRewardTokens;

            // Give some bonus to the referral
            newUser.virtualTokenBalance = this.referralNoPremiumRewardTokens;
          }
          newUser.invitedBy = referrer._id;

          await referrer.save();
        }
      }

      const authToken = await this.jwtService.signAsync({
        userId: newUser.id,
        telegramId,
        email
      });
      newUser.authToken = authToken;
      await newUser.save();

      response.success = true;
      response.userId = newUser.id;
      response.kills = newUser.kills;
      response.tokens = newUser.virtualTokenBalance;
      response.characters = newUser.characters.map(dbCharacterToStruct);
      response.authToken = authToken;
    }

    return response;
  }

  async checkToken(message: UsersCheckTokenMessageRequest) {
    const hasUser = await this.userModel.findOne({authToken: message.authToken});
    const response: UsersCheckTokenMessageResponse = {
      success: hasUser !== undefined,
    };
    return response;
  }

  async getUser(message: UsersGetUserMessageRequest) {
    const user = await this.userModel.findOne({id: message.userId}).populate(['characters']);

    const userBody: UserBody = {
      telegramName: user.telegramName,
      telegramPremium: user.telegramPremium,
  
      virtualTokenBalance: user.virtualTokenBalance,
  
      characters: user.characters.map((c:any) => {
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

    const response: UsersGetUserMessageResponse = {
      user: userBody 
    };
    return response;
  }

  async getFriends(message: UsersGetFriendsMessageRequest) {
    const response: UsersGetFriendsMessageResponse = {
      success: false,
    };
    const user = await this.userModel.findOne({ id: message.userId }).populate(['friendsInvited']);
    if (user)  {
      response.success = true;
      // TODO get friendsInvited
      console.log('ASS');
      console.log(user);

     
      // response.friends = user.friendsInvited.map(friend => {
      //   return {
      //       userId: friend.id,
      //       telegramName: friend.
      //       telegramPremium: boolean;
      //       referralReward: number
      //       online: boolean;
      //       playing: boolean;
      //       possibleToJoinGame: boolean;
      //   }
      // });
     
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
