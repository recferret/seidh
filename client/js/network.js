let _currentGameplayServiceId = undefined;
let _authToken = undefined;

function networkInit(authToken, wsCallback) {
    _authToken = authToken;
    wsConnect(_authToken, wsCallback);
}

async function networkFindAndJoinGame() {
    const findGameResult = await restFindGame(_authToken);

    if (findGameResult && findGameResult.gameplayServiceId) {
        _currentGameplayServiceId = findGameResult.gameplayServiceId;
        wsFindGame(_currentGameplayServiceId);
    } else {
        console.error('Failed to find gameplay service');
    }
}

function networkInput(actionType, movAngle) {
    wsInput(_currentGameplayServiceId, actionType, movAngle);
}