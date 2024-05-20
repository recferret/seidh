import { Injectable } from '@nestjs/common';
import { Telegraf, Markup  } from 'telegraf';
import { message } from 'telegraf/filters'

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
          Markup.button.webApp('Отправить сообщение', 'https://seidh-game.online/'),
        ])
      )
    });

    this.bot.launch();
  }
  
}
