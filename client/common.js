const md = new MobileDetect(window.navigator.userAgent);

function getMobile() {
    return md.mobile();
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
        'orientation:'+ orientation
    );
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
        orientation
    };
}