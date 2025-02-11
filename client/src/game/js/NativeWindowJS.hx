package game.js;

import engine.base.types.TypesBaseEntity;

enum abstract YandexMetricsGoals(String) {
	var JoinSinglePlayerGame = 'JoinSinglePlayerGame';
	var JoinMultiplayerPlayerGame = 'JoinMultiplayerPlayerGame';
}

@:native("window")
extern class NativeWindowJS {

    // Networking
    static function networkInitTg(
        telegramInitData:String,
        userCallback:Dynamic->Void,
        boostCallback:Dynamic->Void,
        gameConfigCallback:Dynamic->Void,
        getCharactersDefaultParamsCallback:Dynamic->Void
    ):Void;
    static function networkInitVk(
        vkAuthRequest:String,
        userCallback:Dynamic->Void,
        boostCallback:Dynamic->Void,
        gameConfigCallback:Dynamic->Void,
        getCharactersDefaultParamsCallback:Dynamic->Void
    ):Void;
    static function networkInitSimple(
        login:String,
        userCallback:Dynamic->Void,
        boostCallback:Dynamic->Void,
        gameConfigCallback:Dynamic->Void,
        getCharactersDefaultParamsCallback:Dynamic->Void
    ):Void;

    static function networkWsInit(callback:Dynamic->Void):Void;
    static function networkFindAndJoinGame(gameType:String):Void;
    static function networkInput(actionType:CharacterActionType, movAngle:Float):Void;
    static function networkBuyBoost(boostId:String, callback:Dynamic->Void):Void;

    static function networkGameStart(callback:Dynamic->Void):Void;
    static function networkGameProgress(
        callback:Dynamic->Void,
        gameId: String,
        mobsSpawned: Int,
        zombiesKilled: Int,
        coinsGained: Int
    ):Void;
    static function networkGameFinish(
        callback:Dynamic->Void,
        gameId: String,
        reason: String,
        mobsSpawned: Int,
        zombiesKilled: Int,
        coinsGained: Int
    ):Void;

    // Common
    static function getAppConfig():Dynamic;
    static function getPlatform():String;
    static function isMobile():Bool;
    static function getScreenParams():Dynamic;
    static function alertScreenParams():Void;
    static function getCanvasAndDpr():Dynamic;
    static function debugAlert(text:String):Void;
    static function listenForScreenOrientationChange(callback:Void->Void):Dynamic;

    // VK
    static function vkGetAppParams(callback:Dynamic->Void):Void;

    // Telegram
    static function tgShowAlert(text:String):Void;
    static function tgGetInitData():String;
    static function tgGetInitDataUnsafe():Dynamic;
    static function tgShareMyRefLink(refLink:String):Void;
    static function tgInitAnalytics():Void;
    static function tgShowBackButton():Void;
    static function tgHideBackButton():Void;
    static function tgBackButtonCallback(callback:Void->Void):Void;

    // Ton
    static function tonConnect(callback:Dynamic->Void):Void;
    static function tonDisconnect(callback:Void->Void):Void;
    static function tonMintRagnar():String;

    // LocalStorage
    static function lsSetItem(key:String, value:String):Void;
    static function lsGetItem(key:String):String;

    // Telemetree
    static function telemetreeInit():Void;

    static function trackHomeClick():Void;
    static function trackBoostsClick():Void;
    static function trackCollectionClick():Void;
    static function trackFriendsClick():Void;

    static function trackPlayClick():Void;
    static function trackCharacterInfoClick():Void;
    static function trackCharacterLvlUpClick():Void;
    static function trackCharacterChangeClick():Void;

    static function trackWalletConnectClick():Void;
    static function trackWalletConnected(address:String):Void;
    static function trackMintRagnarClick():Void;

    static function trackBoostClick(boostId:String, owned:Bool, coins:Int, teeth:Int):Void;
    static function trackBoostDialogClick(boostId:String, action:String, owned:Bool, coins:Int, teeth:Int):Void;
    static function trackBoostBuyResult(boostId:String, success:Bool):Void;

    static function trackInviteFriendClick():Void;

    static function trackGameStarted(gameId: String):Void;
    static function trackGameWin(gameId: String):Void;
    static function trackGameLose(gameId: String):Void;
    static function trackGameClosed(gameId: String):Void;
}