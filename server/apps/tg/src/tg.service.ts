import { Injectable } from '@nestjs/common';
import { Telegraf, Markup } from 'telegraf';
import { message } from 'telegraf/filters';

@Injectable()
export class TgService {
  private readonly bot = new Telegraf(
    '7109468529:AAHvO4toPIdlBVgEJkDc8Yjozx1uXsM4QV8',
  );

  constructor() {
    this.bot.on('callback_query', async (ctx) => {
      console.log('1222');
      console.log(ctx.callbackQuery);
    });

    this.bot.on('inline_query', async (ctx) => {
      console.log('2');
      console.log(ctx.inlineQuery);
    });

    this.bot.on(message('text'), async (ctx) => {
      console.log(ctx.message);
      ctx.reply(
        'Добро пожаловать! Нажмите на кнопку ниже, чтобы запустить приложение',
        Markup.keyboard([
          // Markup.button.webApp('Play Seidh', 'https://seidh-game.online'),
          Markup.button.webApp('Play Seidh', 'https://192.168.1.6:8080'),
          // Markup.button.webApp('Play Seidh', 'https://localhost:8080'),
        ]),
      );
    });

    this.bot.launch();
  }
}
