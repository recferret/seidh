let _currentGameplayServiceId = undefined;
let _playerId = undefined;

function networkInit(playerId, wsCallback) {
    _playerId = playerId;
    wsConnect(_playerId, wsCallback);
}

async function networkFindAndJoinGame() {
    const findGameResult = await restFindGame(_playerId);

    if (findGameResult && findGameResult.gameplayServiceId) {
        _currentGameplayServiceId = findGameResult.gameplayServiceId;
        console.log("Will work with gameplay service " + _currentGameplayServiceId);
        wsFindGame(_playerId, _currentGameplayServiceId);
    } else {
        console.error('Failed to find gameplay service');
    }
}

function networkInput(actionType, movAngle) {
    wsInput(_playerId, _currentGameplayServiceId, actionType, movAngle);
}