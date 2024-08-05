// TODO implement rest wrappers

async function restFindGame(authToken, gameType) {
    const findGameResult = await fetch(restUrl + 'findGame', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': authToken
        },
        body: JSON.stringify({
            gameType
        })
    });

    const findGameData = await findGameResult.json();
    return findGameData;
}

async function restAuthenticate(telegramInitData, login, referrerId) {
    const authenticateResult = await fetch(restUrl + 'authenticate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            telegramInitData,
            login,
            referrerId
        })
    });
    const authenticateData = await authenticateResult.json();
    return authenticateData;
}

async function restGetUser(authToken) {
    const result = await fetch(restUrl + 'user', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': authToken
        }
    });
    const json = await result.json();
    return json;
}

async function restGetBoosts(authToken) {
    const result = await fetch(restUrl + 'boosts', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': authToken
        }
    });
    const json = await result.json();
    return json;
}