async function _getWrapper(url, authToken) {
    const result = await fetch(url, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': authToken
        }
    });
    return await result.json();
}

async function _postWrapper(url, authToken, body) {
    const result = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': authToken
        },
        body: JSON.stringify(body)
    });

    return await result.json();
}

async function restFindGame(authToken, gameType) {
    return await _postWrapper(restUrl + 'findGame', authToken, {
        gameType
    });
}

async function restAuthenticate(telegramInitData, login, referrerId) {
    return await _postWrapper(restUrl + 'auth', {
        telegramInitData,
        login,
        referrerId
    });
}

async function restGetUser(authToken) {
    return await _getWrapper(restUrl + 'user', authToken);
}

async function restGetBoosts(authToken) {
    return await _getWrapper(restUrl + 'boosts', authToken);
}

async function restBuyBoost(authToken, boostId) {
    return await _postWrapper(restUrl + 'boosts', authToken, {
        boostId
    });
}