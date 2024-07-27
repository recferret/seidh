// const restUrl = 'https://api.seidh-game.com/';
const restUrl = 'http://localhost:3003/';
// const socketUrl = 'wss://api.seidh-game.com/';
const socketUrl = 'ws://localhost:3004/';

function getGameConfig() {
    return {
        Production: true,
        DebugDraw: false,
        PlayMusic: false,
        PlaySounds: false,
        TelegramAuth: false,
        Analytics: false,
        Serverless: false,
        TestLogin: _makeId(),
        // TestLogin: 'User1',
        TestReferrerId: '',
        JoinGameType: 'PublicGame', 
    }
}

function _makeId() {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    let counter = 0;
    while (counter < 20) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
      counter += 1;
    }
    return result;
}

function getMobile() {
    return new MobileDetect(window.navigator.userAgent).mobile();
}

function getCanvasAndDpr() {
    return {
        canvas: document.getElementById('webgl'),
        dpr: window.devicePixelRatio,
    }
    // const DPR = window.devicePixelRatio;
    // alert('canvas.width: ' + canvas.width + ', canvas.height: ' + canvas.height);
}

function alertScreenParams() {
    const screenWidth = window.screen.width;
    const screenHeight = window.screen.height;
    const availableScreenWidth = window.screen.availWidth;
    const availableScreenHeight = window.screen.availHeight;
    const windowOuterWidth = window.outerWidth;
    const windowOuterHeight = window.outerHeight;
    const windowInnerWidth = window.innerWidth;
    const windowInnerHeight = window.innerHeight;
    const windowInnerWidthClient = document.documentElement.clientWidth;
    const windowInnerHeightClient = document.documentElement.clientHeight;
    const pageWidth = document.documentElement.scrollWidth;
    const pageHeight = document.documentElement.scrollHeight;
    const dpr = window.devicePixelRatio;

    let orientation = undefined;

    if (window.matchMedia("(orientation: portrait)").matches) {
        orientation = 'portrait';
    }
      
    if (window.matchMedia("(orientation: landscape)").matches) {
        orientation = 'landscape';
    }

    alert(
        'screenWidth:'+ screenWidth + '\n' +
        'screenHeight:'+ screenHeight + '\n' +
        'availableScreenWidth:'+ availableScreenWidth + '\n' +
        'availableScreenHeight:'+ availableScreenHeight + '\n' +
        'windowOuterWidth:'+ windowOuterWidth + '\n' +
        'windowOuterHeight:'+ windowOuterHeight + '\n' +
        'windowInnerWidth:'+ windowInnerWidth + '\n' +
        'windowInnerHeight:'+ windowInnerHeight + '\n' +
        'windowInnerWidthClient:'+ windowInnerWidthClient + '\n' +
        'windowInnerHeightClient:'+ windowInnerHeightClient + '\n' +
        'pageWidth:'+ pageWidth + '\n' +
        'pageHeight:'+ pageHeight + '\n' +
        'orientation:'+ orientation + '\n' +
        'dpr:'+ dpr
    );
}

function debugAlert(text) {
    alert(text);
}

function getScreenParams() {
    const screenWidth = window.screen.width;
    const screenHeight = window.screen.height;
    const availableScreenWidth = window.screen.availWidth;
    const availableScreenHeight = window.screen.availHeight;
    const windowOuterWidth = window.outerWidth;
    const windowOuterHeight = window.outerHeight;
    const windowInnerWidth = window.innerWidth;
    const windowInnerHeight = window.innerHeight;
    const windowInnerWidthClient = document.documentElement.clientWidth;
    const windowInnerHeightClient = document.documentElement.clientHeight;
    const pageWidth = document.documentElement.scrollWidth;
    const pageHeight = document.documentElement.scrollHeight;
    const dpr = window.devicePixelRatio;

    let orientation = undefined;

    if (window.matchMedia("(orientation: portrait)").matches) {
        orientation = 'portrait';
    }
      
    if (window.matchMedia("(orientation: landscape)").matches) {
        orientation = 'landscape';
    }

    return {
        screenWidth, 
        screenHeight, 
        availableScreenWidth, 
        availableScreenHeight, 
        windowOuterWidth, 
        windowOuterHeight, 
        windowInnerWidth, 
        windowInnerHeight, 
        windowInnerWidthClient, 
        windowInnerHeightClient, 
        pageWidth, 
        pageHeight,
        orientation,
        dpr
    };
}