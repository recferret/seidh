async function restFindGame(authToken) {
    const findGameResult = await fetch(restUrl + 'findGame', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': authToken
        }
    });

    const findGameData = await findGameResult.json();
    return findGameData;
}

async function restAuthenticate(telegramInitData, email, referrerId, callback) {
    const authenticateResult = await fetch(restUrl + 'authenticate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            telegramInitData,
            email,
            referrerId
        })
    });
    const authenticateData = await authenticateResult.json();
    if (callback) {
        callback(authenticateData);
    }
}

