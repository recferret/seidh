const url = 'http://localhost:3003/';
// const url = 'http://192.168.1.6:3003/';
// const url = 'https://seidh-game.online/api/';

async function restFindGame(playerId) {
    const findGameResult = await fetch(url + 'findGame', {
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

// TODO return response here
// test data FERRET: query_id=AAEFln8BAAAAAAWWfwH0UjCO&user=%7B%22id%22%3A25138693%2C%22first_name%22%3A%22Andrey%22%2C%22last_name%22%3A%22Sokolov%22%2C%22username%22%3A%22FerretRec%22%2C%22language_code%22%3A%22ru%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1716481616&hash=6c178e00d76e065a0eb274d65d02e637dbc209151b5c6538738d8c7d649c9e01
// test data sofia:  query_id=AAFEJ_ExAwAAAEQn8TGuddzY&user=%7B%22id%22%3A7280338756%2C%22first_name%22%3A%22Sofia%22%2C%22last_name%22%3A%22%22%2C%22language_code%22%3A%22ru%22%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1718130576&hash=97bac32b6a9134e02cf7f91045d82db5908c3b1d62baddbaf2d20e84280e363c

async function restPostTelegramInitData(telegramInitData, startParam, callback) {
    const authenticateResult = await fetch(url + 'authenticate', {
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

