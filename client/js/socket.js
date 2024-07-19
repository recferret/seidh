let socket = undefined;

// const socketUrl = 'ws://localhost:3004/';
const socketUrl = 'wss://api.seidh-game.com/';

function wsConnect(playerId, callback) {
    socket = io(socketUrl, {
        transport: [ "websocket" ],
        auth: {
            playerId
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