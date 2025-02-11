// const restUrl = 'http://localhost:3004/';
// const socketUrl = 'ws://localhost:3005/';
 
// const restUrl = 'https://192.168.1.22:3004/';
// const socketUrl = 'wss://192.168.1.22:3005/';

const restUrl = 'https://api.seidh-game.com/';
const socketUrl = 'wss://api.seidh-game.com/';

function getAppConfig() {
    return {
        // Production: true,
        DebugDraw: false,
        PlayMusic: false,
        PlaySounds: false,
        // TelegramAuth: true,
        // TelegramTestAuth: false,
        // TelegramInitData: 'query_id=AAFEJ_ExAwAAAEQn8TGuddzY&user=%7B%22id%22%3A7280338756%2C%22first_name%22%3A%22Sofia%22%2C%22last_name%22%3A%22%22%2C%22language_code%22%3A%22ru%22%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1718130576&hash=97bac32b6a9134e02cf7f91045d82db5908c3b1d62baddbaf2d20e84280e363c',
        Analytics: false,
        TestLogin: _makeId(),
        // TestLogin: 'User1231',
        TestReferrerId: '',
        JoinGameType: 'TestGame',
    }
}

function getPlatform() {
    if (window.vkBridge != null) {
        return 'VK';
    }
    if (window.Telegram != null) {
        return 'TG';
    }
    return 'NONE';
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

function isMobile() {
    const mobileRE = /(android|bb\d+|meego).+mobile|armv7l|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|redmi|series[46]0|samsungbrowser.*mobile|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i
    const notMobileRE = /CrOS/
    
    const tabletRE = /android|ipad|playbook|silk/i
    
    function isMobile (opts) {
      if (!opts) opts = {}
      let ua = opts.ua
      if (!ua && typeof navigator !== 'undefined') ua = navigator.userAgent
      if (ua && ua.headers && typeof ua.headers['user-agent'] === 'string') {
        ua = ua.headers['user-agent']
      }
      if (typeof ua !== 'string') return false
    
      let result =
        (mobileRE.test(ua) && !notMobileRE.test(ua)) ||
        (!!opts.tablet && tabletRE.test(ua))
    
      if (
        !result &&
        opts.tablet &&
        opts.featureDetect &&
        navigator &&
        navigator.maxTouchPoints > 1 &&
        ua.indexOf('Macintosh') !== -1 &&
        ua.indexOf('Safari') !== -1
      ) {
        result = true
      }
    
      return result
    }

    return isMobile();
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
    const orientation = screenHeight > screenWidth ? 'portrait' : 'landscape';

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

function listenForScreenOrientationChange(callback) {
    window.addEventListener("orientationchange", (event) => {
        if (callback != null) {
            const portrait = event.target.screen.orientation.angle == 0;
            if (portrait) {
                canvas.width = canvasWidth ;
                canvas.height = canvasHeight;
                canvas.style.width = canvasStyleWidth;
                canvas.style.height = canvasStyleHeight;
            } else {
                canvas.width = canvasHeight;
                canvas.height = canvasWidth;
                canvas.style.width = canvasStyleHeight;
                canvas.style.height = canvasStyleWidth;
            }
            callback();
        }
    });
}

const canvas = document.getElementById('webgl');

const canvasWidth = canvas.width;
const canvasHeight = canvas.height;
const canvasStyleWidth = canvas.style.width;
const canvasStyleHeight = canvas.style.height;
const isPortraitByDefault = window.innerHeight > window.innerWidth;