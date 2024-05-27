let socket = undefined;

function wsConnect(playerId, callback) {
    socket = io('ws://localhost:3004', {
        transport: [ "websocket" ],
        auth: {
            playerId
        }
    });
        
    //
    // Socket.IO Events
    //

    socket.on('connect', function() {
        console.log('Client connected');
    });
        
    socket.on('exception', function(data) {
        console.e('ws exception', data);
        console.log('data', data);
    });

    socket.on('disconnect', function() {
        console.log('ws Disconnected');
    });

    //
    // Server -> Client events
    //

    socket.on('GameInit', function(data) {
        // console.log('WS GameInit', data);
        callback({type: 'GameInit', data});
    });

    socket.on('GameState', function(data) {
        // console.log('WS GameState', data);
        callback({type: 'GameState', data});
    });

    socket.on('CreateCharacter', function(data) {
        // console.log('WS CreateCharacter', data);
        callback({type: 'CreateCharacter', data});
    });

    socket.on('DeleteCharacter', function(data) {
        // console.log('WS DeleteCharacter', data);
        callback({type: 'DeleteCharacter', data});
    });
}

function wsFindGame(playerId, gameplayServiceId) {
    socket.emit('FindGame', {
        playerId,
        gameplayServiceId
    });
}

function wsInput(playerId, gameplayServiceId, actionType, movAngle) {
    socket.emit('Input', {
        playerId,
        gameplayServiceId,
        actionType, 
        movAngle
    });
}