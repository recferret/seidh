import { Injectable } from '@nestjs/common';
import { Telegraf, Markup  } from 'telegraf';
import { message } from 'telegraf/filters'
import { link } from 'telegraf/format';

@Injectable()
export class TgService {
  private readonly bot = new Telegraf('7109468529:AAHvO4toPIdlBVgEJkDc8Yjozx1uXsM4QV8');

  constructor() {
    this.bot.on('callback_query', async (ctx) => {
      console.log('1');
      console.log(ctx.callbackQuery);

      await ctx.telegram.answerCbQuery(ctx.callbackQuery.id, 'here is your game', {url:'https://43a3-99-80-128-27.ngrok-free.app'})
    })
    
    this.bot.on('inline_query', async (ctx) => {
      console.log('2');
      console.log(ctx.inlineQuery);
    })

    this.bot.on(message('text'), async (ctx) => {
      console.log(ctx.message.text);
      ctx.reply(
        'Добро пожаловать! Нажмите на кнопку ниже, чтобы запустить приложение',
        Markup.keyboard([
          Markup.button.webApp('Отправить сообщение', 'https://192.168.1.6:8080'),
        ])
      )
    });


    // this.bot.command("link", ctx =>
    //   /*
    //     Go to @Botfather and create a new app for your bot first, using /newapp
    //     Then modify this link appropriately.
      
    //     startapp is optional.
    //     If provided, it will be passed as start_param in initData
    //     and as ?tgWebAppStartParam=$command in the Web App URL
    //   */
    //   ctx.reply(link("Launch", "https://seidh-game.online")),
    // );


    this.bot.launch();
  }
  
}
