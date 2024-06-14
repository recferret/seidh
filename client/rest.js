// const restUrl = 'http://localhost:3003/';
// const url = 'http://192.168.1.6:3003/';
const restUrl = 'https://seidh-game.online/api/';
// const restUrl = 'http://23.111.202.19:3003/';

async function restFindGame(playerId) {
    const findGameResult = await fetch(restUrl + 'findGame', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            playerId
        })
    });

    const findGameData = await findGameResult.json();
    return findGameData;
}

async function restPostTelegramInitData(telegramInitData, startParam, callback) {
    const authenticateResult = await fetch(restUrl + 'authenticate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            telegramInitData,
            startParam
        })
    });
    const authenticateData = await authenticateResult.json();
    if (callback) {
        callback(authenticateData);
    }
}

