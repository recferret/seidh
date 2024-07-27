import { io } from 'socket.io-client';

const restUrl = 'http://localhost:3003/';
const socketUrl = 'ws://localhost:3004/';

let users = 0;
const maxUsers = 8;

function makeId() {
  let result = '';
  const characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const charactersLength = characters.length;
  let counter = 0;
  while (counter < 20) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
    counter += 1;
  }
  return result;
}

class SocketInstance {
  constructor(user) {
    this.init(user);
  }

  async init(user) {
    const authResponse = await this.restAuthenticate(user);
    const authToken = 'Bearer ' + authResponse.authToken;

    const findGameResult = await this.restFindGame(authToken);

    const socket = io(socketUrl, {
      auth: {
        authToken,
      },
    });

    socket.on('connect', () => {
      socket.emit('FindGame', {
        gameId: findGameResult.gameId,
        gameplayServiceId: findGameResult.gameplayServiceId,
      });
    });
  }

  async restAuthenticate(login) {
    const authenticateResult = await fetch(restUrl + 'authenticate', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: JSON.stringify({
        login,
      }),
    });
    const authenticateData = await authenticateResult.json();
    return authenticateData;
  }

  async restFindGame(authToken) {
    const findGameResult = await fetch(restUrl + 'findGame', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8',
        Authorization: authToken,
      },
      body: JSON.stringify({
        gameType: 'PublicGame',
      }),
    });

    const findGameData = await findGameResult.json();
    return findGameData;
  }
}

// New connection every second
const interval = setInterval(() => {
  new SocketInstance(makeId());
  console.log(`Users connected ${++users} / ${maxUsers}`);

  if (users == maxUsers) {
    clearInterval(interval);
  }
}, 1000);
