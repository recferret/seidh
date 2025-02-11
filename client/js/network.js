let _currentGameId = undefined;
let _currentGameplayServiceId = undefined;
let _authToken = undefined;

async function networkInitTg(telegramInitData, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback) {
    const authResponse = await restAuthenticateTg(telegramInitData);
    await _networkInit(authResponse, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback);
}

async function networkInitVk(vkAuthRequest, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback) {
    const authResponse = await restAuthenticateVk(vkAuthRequest);
    await _networkInit(authResponse, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback);
}

async function networkInitSimple(login, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback) {
    const authResponse = await restAuthenticateSimple(login);
    await _networkInit(authResponse, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback);
}

async function _networkInit(authResponse, userCallback, boostCallback, getGameConfigCallback, getCharactersDefaultParamsCallback) {
    if (authResponse.success) {
        _authToken = 'Bearer ' + authResponse.authToken;
        const userResponse = await restGetUser(_authToken)
        if (userResponse.success) {
            await networkGameGetConfig(getGameConfigCallback);
            await networkGetCharactersDefaultParams(getCharactersDefaultParamsCallback);
            await networkGetBoosts(boostCallback);
            if (userCallback) {
                userCallback(userResponse.user);
            }
        } else {
            console.error('Failed to get user');
        }
    } else {
        console.error('Failed to authenticate');
    }
}

// ----------------------------------
// Multiplayer
// ----------------------------------

function networkWsInit(wsCallback) {
    wsConnect(_authToken, wsCallback);
}

async function networkFindAndJoinGame(gameType) {
    const findGameResult = await restFindGame(_authToken, gameType);

    if (findGameResult && findGameResult.gameplayServiceId) {
        _currentGameId = findGameResult.gameId;
        _currentGameplayServiceId = findGameResult.gameplayServiceId;
        wsFindGame(_currentGameId, _currentGameplayServiceId);
    } else {
        console.error('Failed to find gameplay service');
    }
}

function networkInput(actionType, movAngle) {
    wsInput(actionType, movAngle);
}

// ----------------------------------
// REST wrappers
// ----------------------------------

async function networkGameGetConfig(callback) {
    const result = await restGameGetConfig(_authToken);
    if (callback) {
        callback(result);
    }
}

async function networkGameStart(callback) {
    const result = await restGameStart(_authToken);
    if (callback) {
        callback(result);
    }
}

async function networkGameProgress(callback, gameId, mobsSpawned, zombiesKilled, coinsGained) {
    const result = await restGameProgress(_authToken, {
        gameId, mobsSpawned, zombiesKilled, coinsGained
    });
    if (callback) {
        callback(result);
    }
}

async function networkGameFinish(callback, gameId, reason, mobsSpawned, zombiesKilled, coinsGained) {
    const result = await restGameFinish(_authToken, {
        gameId, reason, mobsSpawned, zombiesKilled, coinsGained
    });
    if (callback) {
        callback(result);
    }
}

async function networkGetCharactersDefaultParams(callback) {
    const result = await restGetCharactersDefaultParams(_authToken);
    if (callback) {
        callback(result);
    }
}

async function networkGetBoosts(callback) {
    const boostsResult = await restGetBoosts(_authToken);
    if (callback) {
        callback(boostsResult.boosts);
    }
}

async function networkBuyBoost(boostId, callback) {
    const buyBoostResult = await restBuyBoost(_authToken, boostId);
    if (callback) {
        callback(buyBoostResult);
    }
}