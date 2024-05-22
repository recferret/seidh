// const url = 'http://localhost:4005/';
const url = 'http://192.168.1.6:3005/';

function restJoinGame(playerId, gameType) {
    fetch('/rest/joinGame');
}

function restPostTelegramInitData(initData) {
    fetch(url + 'validateTelegramInitData', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            initData: 'FFFF'
        })
    });
}