// const url = 'http://localhost:4005/';
// const url = 'https://192.168.1.6:3005/';

function restJoinGame(playerId, gameType) {
    fetch('/rest/joinGame');
}


// TODO return response here
// test data: query_id=AAEFln8BAAAAAAWWfwH0UjCO&user=%7B%22id%22%3A25138693%2C%22first_name%22%3A%22Andrey%22%2C%22last_name%22%3A%22Sokolov%22%2C%22username%22%3A%22FerretRec%22%2C%22language_code%22%3A%22ru%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1716481616&hash=6c178e00d76e065a0eb274d65d02e637dbc209151b5c6538738d8c7d649c9e01
function restPostTelegramInitData(initData) {
    fetch('https://seidh-game.online/validateTelegramInitData', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify({
            initData
        })
    });
}

