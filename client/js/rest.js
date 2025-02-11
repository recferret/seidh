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

// ------------------------------------------
// Gameplay API
// ------------------------------------------

async function restFindGame(authToken, gameType) {
    return await _postWrapper(restUrl + 'findGame', authToken, {
        gameType
    });
}

// ------------------------------------------
// Auth and User API
// ------------------------------------------

async function restAuthenticateTg(telegramInitData) {
    return await _postWrapper(restUrl + 'auth/tg', undefined, {
        telegramInitData,
    });
}

async function restAuthenticateVk(vkAuthRequest) {
    return await _postWrapper(restUrl + 'auth/vk', undefined, vkAuthRequest);
}

async function restAuthenticateSimple(login) {
    return await _postWrapper(restUrl + 'auth/simple', undefined, {
        login,
    });
}

async function restGetUser(authToken) {
    return await _getWrapper(restUrl + 'users', authToken);
}

// ------------------------------------------
// Game API
// ------------------------------------------

async function restGameGetConfig(authToken) {
    return await _getWrapper(restUrl + 'game/config', authToken);
}

async function restGameStart(authToken) {
    return await _postWrapper(restUrl + 'game/start', authToken);
}

async function restGameProgress(authToken, body) {
    return await _postWrapper(restUrl + 'game/progress', authToken, body);
}

async function restGameFinish(authToken, body) {
    return await _postWrapper(restUrl + 'game/finish', authToken, body);
}

// ------------------------------------------
// Characters API
// ------------------------------------------

async function restGetCharactersDefaultParams(authToken) {
    return await _getWrapper(restUrl + 'characters/default-params', authToken);
}

// ------------------------------------------
// Boosts API
// ------------------------------------------

async function restGetBoosts(authToken) {
    return await _getWrapper(restUrl + 'boosts', authToken);
}

async function restBuyBoost(authToken, boostId) {
    return await _postWrapper(restUrl + 'boosts', authToken, {
        boostId
    });
}