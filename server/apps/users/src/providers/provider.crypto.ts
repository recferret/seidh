import { Injectable } from '@nestjs/common';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const crypto = require('crypto');

@Injectable()
export class ProviderCrypto {
  async generateNewRsaKeyPair() {
    const keys: { publicKey: string; privateKey: string } =
      crypto.generateKeyPairSync('rsa', {
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

  parseTelegramInitData(botKey: string, telegramInitData: string) {
    const encoded = decodeURIComponent(telegramInitData);

    const secret = crypto.createHmac('sha256', 'WebAppData').update(botKey);
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
