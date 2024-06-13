let socket = undefined;

// const e = 'ws://localhost:3004/';
// const e = 'http://192.168.1.6:3003/';
const socketUrl = 'wss://seidh-game.online/';
// const socketUrl = 'ws://23.111.202.19:3004/'

function wsConnect(playerId, callback) {
    // socket = io('wss://23.111.202.19:3004', {
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