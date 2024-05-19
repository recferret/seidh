let socket = undefined;

function wsConnect(playerId) {
    socket = io('ws://localhost:3000', {
    // const socket = io('ws://localhost:3082', {
        transport: [ "websocket" ],
        auth: {
            playerId
        }
    });
        
    socket.on('connect', function() {
        console.log('Client connected');
    });
        
    socket.on('exception', function(data) {
        console.log('exception', data);
        console.log('data', data);
    });

    socket.on('disconnect', function() {
        console.log('Disconnected');
    });

    socket.on('game_init', function(data) {
        console.log('game_init data:');
        console.log(data);
    });
}

function wsJoinGame(gameplayServiceId) {
    socket.emit('joinGame', {
        gameplayServiceId
    });
}