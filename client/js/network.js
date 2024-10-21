let _currentGameId = undefined;
let _currentGameplayServiceId = undefined;
let _authToken = undefined;

async function networkAuthAndGetUser(telegramInitData, login, referrerId, userCallback, boostCallback) {
    const authResponse = await restAuthenticate(telegramInitData, login, referrerId);
    if (authResponse.success) {
        _authToken = 'Bearer ' + authResponse.authToken;
        const userResponse = await restGetUser(_authToken)
        if (userResponse.success) {
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

async function networkGetBoosts(callback) {
    const boostsResult = await restGetBoosts(_authToken);
    if (boostsResult.success) {
        if (callback) {
            callback(boostsResult.boosts);
        }
    } else {
        console.error('Failed to get boosts');
    }
}

async function networkBuyBoost(boostId, callback) {
    const buyBoostResult = await restBuyBoost(_authToken, boostId);
    if (buyBoostResult.success) {
        if (callback) {
            callback(buyBoostResult);
        }
    } else {
        tgShowAlert('Failed to buy boost');
    }

}