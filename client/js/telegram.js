function tgInit() {
    if (window.Telegram != null) {
        window.Telegram.WebApp.expand();
        window.Telegram.WebApp.disableVerticalSwipes();
        window.Telegram.WebApp.requestFullscreen();
    }
}

function tgShowBackButton() {
    if (window.Telegram != null) {
        window.Telegram.WebApp.BackButton.show();
    }
}

function tgHideBackButton() {
    if (window.Telegram != null) {
        window.Telegram.WebApp.BackButton.hide();
    }
}

function tgBackButtonCallback(callback) {
    if (window.Telegram != null) {
        window.Telegram.WebApp.BackButton.onClick(callback);
    }
}

function tgShowAlert(text) {
    if (window.Telegram != null) {
        window.Telegram.WebApp.showAlert(text);
    }
}

function tgGetInitData() {
    if (window.Telegram != null) {
        return window.Telegram.WebApp.initData;
    } else {
        return null;
    }
    // My main TG user data
    // return 'query_id=AAEFln8BAAAAAAWWfwH0UjCO&user=%7B%22id%22%3A25138693%2C%22first_name%22%3A%22Andrey%22%2C%22last_name%22%3A%22Sokolov%22%2C%22username%22%3A%22FerretRec%22%2C%22language_code%22%3A%22ru%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1716481616&hash=6c178e00d76e065a0eb274d65d02e637dbc209151b5c6538738d8c7d649c9e01';

    // My second account
    // return 'query_id=AAFEJ_ExAwAAAEQn8TGuddzY&user=%7B%22id%22%3A7280338756%2C%22first_name%22%3A%22Sofia%22%2C%22last_name%22%3A%22%22%2C%22language_code%22%3A%22ru%22%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1718130576&hash=97bac32b6a9134e02cf7f91045d82db5908c3b1d62baddbaf2d20e84280e363c';

}

function tgGetInitDataUnsafe() {
    if (window.Telegram != null) {
        return window.Telegram.WebApp.initDataUnsafe;
    } else {
        return null;
    }
}

function tgShareMyRefLink(refLink) {
    if (window.Telegram != null) {
        window.Telegram.WebApp.openTelegramLink(
            `https://t.me/share/url?url=https://t.me/SeidhGameBot/seidhgame?startapp=${refLink}`
        );
    }
}

function tgInitAnalytics() {
    // window.telegramAnalytics.init({
    //     token: 'eyJhcHBfbmFtZSI6InNlaWRoIiwiYXBwX3VybCI6Imh0dHBzOi8vdC5tZS9TZWlkaEdhbWVCb3QiLCJhcHBfZG9tYWluIjoiaHR0cDovL3NlaWRoLWdhbWUuY29tIn0=!pUv7pZnXbAFxddf3c/+ceFu/sQ3GA9YFJPqwharYGMY=',
    //     appName: 'seidh',
    // });
}