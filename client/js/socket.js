let socket = undefined;

function wsConnect(authToken, callback) {
    socket = io(socketUrl, {
        transport: [ "websocket" ],
        auth: {
            authToken
        }
    });
        
    //
    // Socket.IO Events
    //

    socket.on('connect', function() {
    });
        
    socket.on('exception', function(data) {
        console.error('ws exception', data);
    });

    socket.on('disconnect', function() {
        console.log('ws Disconnected');
    });

    //
    // Server -> Client events
    //

    socket.on('GameInit', function(data) {
        callback({type: 'GameInit', data});
    });

    socket.on('GameState', function(data) {
        callback({type: 'GameState', data});
    });

    socket.on('LoopState', function(data) {
        callback({type: 'LoopState', data});
    });

    socket.on('CreateCharacter', function(data) {
        callback({type: 'CreateCharacter', data});
    });

    socket.on('DeleteCharacter', function(data) {
        callback({type: 'DeleteCharacter', data});
    });

    socket.on('CreateConsumable', function(data) {
        callback({type: 'CreateConsumable', data});
    });

    socket.on('CharacterActions', function(data) {
        callback({type: 'CharacterActions', data});
    });
}

function wsFindGame(gameplayServiceId) {
    socket.emit('FindGame', {
        gameplayServiceId
    });
}

function wsInput(gameplayServiceId, actionType, movAngle) {
    socket.emit('Input', {
        gameplayServiceId,
        actionType, 
        movAngle
    });
}