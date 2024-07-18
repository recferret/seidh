import { BoostBody, BoostsGetMessageRequest, BoostsGetMessageResponse } from '@app/seidh-common/dto/boost/boost.buy.boosts.msg';
import { BoostsBuyBoostMessageRequest, BoostsBuyBoostMessageResponse } from '@app/seidh-common/dto/boost/boost.get.boosts.msg';
import { Boost } from '@app/seidh-common/schemas/schema.boost';
import { User } from '@app/seidh-common/schemas/schema.user';
import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class BoostService implements OnModuleInit {

  private readonly boosts: Array<Boost> = [];

  private static readonly BOOST_EXP_BOOST_1_NAME = 'Exp boost 1';
  private static readonly BOOST_EXP_BOOST_1_DESCRIPTION = '+50% exp';
  private static readonly BOOST_EXP_BOOST_2_NAME = 'Exp boost 2';
  private static readonly BOOST_EXP_BOOST_2_DESCRIPTION = '+100% exp';

  private static readonly BOOST_POTION_DROP_1_NAME = 'Potion drop 1';
  private static readonly BOOST_POTION_DROP_1_DESCRIPTION = 'Enable potion drop';
  private static readonly BOOST_POTION_DROP_2_NAME = 'Potion drop 2';
  private static readonly BOOST_POTION_DROP_2_DESCRIPTION = 'More and better potions drop';

  private static readonly BOOST_MAX_POTIONS_1_NAME = 'Max potions 1';
  private static readonly BOOST_MAX_POTIONS_1_DESCRIPTION = 'Custom potions capacity +1';
  private static readonly BOOST_MAX_POTIONS_2_NAME = 'Max potions 2';
  private static readonly BOOST_MAX_POTIONS_2_DESCRIPTION = 'Custom potions capacity +2';
  private static readonly BOOST_MAX_POTIONS_3_NAME = 'Max potions 3';
  private static readonly BOOST_MAX_POTIONS_3_DESCRIPTION = 'Custom potions capacity +3';

  private static readonly BOOST_PRAYER_1_NAME = 'Thor prayer';
  private static readonly BOOST_PRAYER_1_DESCRIPTION = '+100% dmg for 1h';

  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    @InjectModel(Boost.name) private boostModel: Model<Boost>,
  ) {
  }

  async onModuleInit() {
    const boosts = await this.boostModel.find();
    if (!boosts) {
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_EXP_BOOST_1_NAME,
          description: BoostService.BOOST_EXP_BOOST_1_DESCRIPTION,
          order: 1,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_EXP_BOOST_2_NAME,
          description: BoostService.BOOST_EXP_BOOST_2_DESCRIPTION,
          order: 2,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_POTION_DROP_1_NAME,
          description: BoostService.BOOST_POTION_DROP_1_DESCRIPTION,
          order: 3,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_POTION_DROP_2_NAME,
          description: BoostService.BOOST_POTION_DROP_2_DESCRIPTION,
          order: 4,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_MAX_POTIONS_1_NAME,
          description: BoostService.BOOST_MAX_POTIONS_1_DESCRIPTION,
          order: 5,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_MAX_POTIONS_2_NAME,
          description: BoostService.BOOST_MAX_POTIONS_2_DESCRIPTION,
          order: 6,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_MAX_POTIONS_3_NAME,
          description: BoostService.BOOST_MAX_POTIONS_3_DESCRIPTION,
          order: 7,
          price: 100
        })
      );
      this.boosts.push(
        await this.boostModel.create({
          name: BoostService.BOOST_PRAYER_1_NAME,
          description: BoostService.BOOST_PRAYER_1_DESCRIPTION,
          order: 8,
          price: 100
        })
      );
    } else {
      this.boosts.push(...boosts);
    }
  }

  async getBoosts(message: BoostsGetMessageRequest) {
    const response: BoostsGetMessageResponse = {
      success: false
    };

    const user = await this.userModel.findOne({ id: message.userId });
    if (!user) {
      response.message = 'User not found';
      return response;
    }

    const boosts = this.boosts.sort((a, b) => a.order - b.order).map((boost) => {
      const boostBody:BoostBody = {
        id: boost.id,
        order: boost.order,
        name: boost.name,
        description: boost.description,
        price: boost.price,
        accquired: false,
      };

      switch(boost.name) {
        case BoostService.BOOST_EXP_BOOST_1_NAME:
          if (user.hasExpBoost1) {
            boostBody.accquired = true;
          }
          break;
  
        case BoostService.BOOST_EXP_BOOST_2_NAME:
          if (user.hasExpBoost2) {
            boostBody.accquired = true;
          }
          break;
      
        case BoostService.BOOST_POTION_DROP_1_NAME:
          if (user.hasPotionDropBoost1) {
            boostBody.accquired = true;
          }
          break;
      
        case BoostService.BOOST_POTION_DROP_2_NAME:
          if (user.hasPotionDropBoost2) {
            boostBody.accquired = true;
          }
          break;
      
        case BoostService.BOOST_MAX_POTIONS_1_NAME:
          if (user.hasMaxPotionBoost1) {
            boostBody.accquired = true;
          }
          break;
      
        case BoostService.BOOST_MAX_POTIONS_2_NAME:
          if (user.hasMaxPotionBoost2) {
            boostBody.accquired = true;
          }
          break;
      
        case BoostService.BOOST_MAX_POTIONS_3_NAME:
          if (user.hasMaxPotionBoost3) {
            boostBody.accquired = true;
          }
          break;
      }

      return boostBody;
    });

    response.success = true;
    response.boosts = boosts;

    return response;
  }
 
  async buyBoost(message: BoostsBuyBoostMessageRequest) {
    const response:BoostsBuyBoostMessageResponse = {
      success: false,
    };
    const boost = this.boosts.find(boost => boost.id == message.boostId);
    if (!boost) {
      response.message = 'Boost not found';
      return response;
    }
    const user = await this.userModel.findOne({ id: message.userId });
    if (!user) {
      response.message = 'User not found';
      return response;
    }
    if (user.virtualTokenBalance < boost.price) {
      response.message = 'Not enough coins';
      return response;
    } else {
      // TODO make sure that balance is a number
      user.virtualTokenBalance -= boost.price;
    }

    // Make sure that user does not have particular boost yet
    switch(boost.name) {
      case BoostService.BOOST_EXP_BOOST_1_NAME:
        if (!user.hasExpBoost1) {
          user.hasExpBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_EXP_BOOST_2_NAME:
        if (!user.hasExpBoost2) {
          user.hasExpBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;
    
      case BoostService.BOOST_POTION_DROP_1_NAME:
        if (!user.hasPotionDropBoost1) {
          user.hasPotionDropBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;
    
      case BoostService.BOOST_POTION_DROP_2_NAME:
        if (!user.hasPotionDropBoost2) {
          user.hasPotionDropBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;
    
      case BoostService.BOOST_MAX_POTIONS_1_NAME:
        if (!user.hasMaxPotionBoost1) {
          user.hasMaxPotionBoost1 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;
    
      case BoostService.BOOST_MAX_POTIONS_2_NAME:
        if (!user.hasMaxPotionBoost2) {
          user.hasMaxPotionBoost2 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;
    
      case BoostService.BOOST_MAX_POTIONS_3_NAME:
        if (!user.hasMaxPotionBoost3) {
          user.hasMaxPotionBoost3 = true;
        } else {
          response.message = 'Already aqquired';
          return response;
        }
        break;

      case BoostService.BOOST_PRAYER_1_NAME:
        // TODO implement boost here
        break;
    }

    await user.save();

    response.success = true;
  }
  
}
