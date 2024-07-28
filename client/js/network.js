let _currentGameId = undefined;
let _currentGameplayServiceId = undefined;
let _authToken = undefined;

async function networkAuthAndGetUser(telegramInitData, login, referrerId, callback) {
    const authResponse = await restAuthenticate(telegramInitData, login, referrerId);
    if (authResponse.success) {
        _authToken = 'Bearer ' + authResponse.authToken;
        const userResponse = await restGetUser(_authToken)
        if (userResponse.success) {
            if (callback) {
                callback(userResponse.user);
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