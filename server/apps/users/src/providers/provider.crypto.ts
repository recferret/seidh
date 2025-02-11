import { parse, validate3rd } from '@telegram-apps/init-data-node';

import { Injectable } from '@nestjs/common';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const crypto = require('crypto');

@Injectable()
export class ProviderCrypto {
  async generateNewRsaKeyPair() {
    const keys: { publicKey: string; privateKey: string } = crypto.generateKeyPairSync('rsa', {
      modulusLength: 4096,
      publicKeyEncoding: {
        type: 'spki',
        format: 'pem',
      },
      privateKeyEncoding: {
        type: 'pkcs8',
        format: 'pem',
        cipher: 'aes-256-cbc',
        passphrase: 'pr',
      },
    });
    return keys;
  }

  // 7109468529:AAGADzMfBBUpEqfXafnh_Mgq9XqjFqAdgJY

  async parseTelegramInitData(botKey: string, telegramInitData: string) {
    const botId = Number(botKey.split(':')[0]);
    await validate3rd(telegramInitData, botId);
    const initData = parse(telegramInitData);

    return {
      user: initData.user,
    };
  }

  verifyVkLaunchParams(secretKey: string, searchOrParsedUrlQuery: Object) {
    let sign: string;
    const queryParams = [];

    const processQueryParam = (key, value) => {
      if (typeof value === 'string') {
        if (key === 'sign') {
          sign = value;
        } else if (key.startsWith('vk_')) {
          queryParams.push({ key, value });
        }
      }
    };

    if (typeof searchOrParsedUrlQuery === 'string') {
      const formattedSearch = searchOrParsedUrlQuery.startsWith('?')
        ? searchOrParsedUrlQuery.slice(1)
        : searchOrParsedUrlQuery;
      for (const param of formattedSearch.split('&')) {
        const [key, value] = param.split('=');
        processQueryParam(key, value);
      }
    } else {
      for (const key of Object.keys(searchOrParsedUrlQuery)) {
        const value = searchOrParsedUrlQuery[key];
        processQueryParam(key, value);
      }
    }

    if (!sign || queryParams.length === 0) {
      return false;
    }

    const queryString = queryParams
      .sort((a, b) => a.key.localeCompare(b.key))
      .reduce((acc, { key, value }, idx) => {
        return acc + (idx === 0 ? '' : '&') + `${key}=${encodeURIComponent(value)}`;
      }, '');

    const paramsHash = crypto
      .createHmac('sha256', secretKey)
      .update(queryString)
      .digest()
      .toString('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=$/, '');

    return paramsHash === sign;
  }
}
