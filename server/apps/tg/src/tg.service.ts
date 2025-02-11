// import { Markup, Telegraf } from 'telegraf';
// import { message } from 'telegraf/filters';
import { Bot, GrammyError, HttpError } from 'grammy';

import { Injectable } from '@nestjs/common';

import { EnvService } from '@lib/env/env.service';

import {
  TgServiceCreateInvoiceRequest,
  TgServiceCreateInvoiceResponse,
} from '@lib/seidh-common/dto/tg/tg.invoice-create';

@Injectable()
export class TgService {
  private readonly bot: Bot;

  constructor(private readonly envService: EnvService) {
    this.bot = new Bot(this.envService.get('TG_BOT_KEY'));

    // this.bot = new Telegraf(process.env.TG_BOT_KEY);

    // this.bot.on('callback_query', async (ctx) => {
    //   console.log('1222');
    //   console.log(ctx.callbackQuery);
    // });

    // this.bot.on('inline_query', async (ctx) => {
    //   console.log('2');
    //   console.log(ctx.inlineQuery);
    // });

    // this.bot.on(message('text'), async (ctx) => {
    //   console.log(ctx.message);
    //   ctx.reply(
    //     'Добро пожаловать! Нажмите на кнопку ниже, чтобы запустить приложение',
    //     Markup.keyboard([
    //       // Markup.button.webApp('Play Seidh', 'https://seidh-game.online'),
    //       Markup.button.webApp('Play Seidh', 'https://192.168.1.6:8080'),
    //       // Markup.button.webApp('Play Seidh', 'https://localhost:8080'),
    //     ]),
    //   );
    // });

    // this.bot.launch();

    this.bot.command('start', (ctx) => ctx.reply('Welcome! Up and running.'));

    this.bot.catch((err) => {
      const ctx = err.ctx;
      console.error(`Ошибка при обработке обновления ${ctx.update.update_id}:`);
      const e = err.error;
      if (e instanceof GrammyError) {
        console.error('Ошибка в запросе:', e.description);
      } else if (e instanceof HttpError) {
        console.error('Не удалось связаться с Telegram:', e);
      } else {
        console.error('Неизвестная ошибка:', e);
      }
    });

    this.bot.start();
  }

  // TODO RMK to usecase
  public async createInvoiceLink(request: TgServiceCreateInvoiceRequest) {
    const response: TgServiceCreateInvoiceResponse = {
      success: false,
    };

    const title = 'Test Product';
    const description = 'Test description';
    const payload = '{}';
    const currency = 'XTR';
    const prices = [{ amount: 10, label: 'Test Product' }];

    const invoiceLink = await this.bot.api.createInvoiceLink(
      title,
      description,
      payload,
      '', // Provider token must be empty for Telegram Stars
      currency,
      prices,
    );

    response.url = invoiceLink;

    return response;
    // TgServiceCreateInvoiceResponse
  }
}
