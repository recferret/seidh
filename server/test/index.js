const playerId = 'player_1';

async function init() {
    const findGameResult = await fetch('http://localhost:3003/findGame', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            playerId
        })
    });

    const findGameData = await findGameResult.json();

    const socket = io('ws://localhost:3004', {
        transport: [ "websocket" ],
        auth: {    
            playerId: "player_1"
        }
    });
    socket.on('connect', function() {
        console.log('Connected');

        socket.emit('FindGame', {
            playerId,
            gameplayServiceId: findGameData.gameplayServiceId
        });
    });
    socket.on('exception', function(data) {
        console.log('Exception', data);
    });
    socket.on('disconnect', function() {
        console.log('Disconnected');
    });
}

init();