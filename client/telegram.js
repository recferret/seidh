function tgExpand() {
    const tg = window.Telegram.WebApp;
    tg.expand();
}

function tgGetInitData() {
    return window.Telegram.WebApp.initData;
    // return 'query_id=AAEFln8BAAAAAAWWfwH0UjCO&user=%7B%22id%22%3A25138693%2C%22first_name%22%3A%22Andrey%22%2C%22last_name%22%3A%22Sokolov%22%2C%22username%22%3A%22FerretRec%22%2C%22language_code%22%3A%22ru%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1716481616&hash=6c178e00d76e065a0eb274d65d02e637dbc209151b5c6538738d8c7d649c9e01';
}

function tgGetInitDataUnsafe() {
    return window.Telegram.WebApp.initDataUnsafe;
}

function tgShareMyRefLink(refLink) {
    window.Telegram.WebApp.openTelegramLink(
        `https://t.me/share/url?url=https://t.me/SeidhGameBot/seidhgame?startapp=${refLink}`
    );
}