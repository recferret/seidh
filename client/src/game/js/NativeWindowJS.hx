package game.js;

import engine.base.BaseTypesAndClasses.CharacterActionType;

enum abstract YandexMetricsGoals(String) {
	var JoinSinglePlayerGame = 'JoinSinglePlayerGame';
	var JoinMultiplayerPlayerGame = 'JoinMultiplayerPlayerGame';
}

@:native("window")
extern class NativeWindowJS {

    // Networking
    static function networkInit(authToken:String, callback:Dynamic->Void):Void;
    static function networkFindAndJoinGame():Void;
    static function networkInput(actionType:CharacterActionType, movAngle:Float):Void;

    // Rest
    static function restAuthenticate(telegramInitData:String, email:String, referrerId:String, callback:Dynamic->Void):Void;

    // Common
    static function getGameConfig():Dynamic;
    static function getMobile():String;
    static function getScreenParams():Dynamic;
    static function alertScreenParams():Void;
    static function getCanvasAndDpr():Dynamic;
    static function debugAlert(text:String):Void;

    // Telegram
    static function tgExpand():Void;
    static function tgGetInitData():String;
    static function tgGetInitDataUnsafe():Dynamic;
    static function tgShareMyRefLink(refLink:String):Void;

    // Ton
    static function tonConnect(callback:Dynamic->Void):Void;
    static function tonMintRagnar():String;

    // LocalStorage
    static function lsSetItem(key:String, value:String):Void;
    static function lsGetItem(key:String):String;

    // Telemetree
    static function telemetreeInit(isTelegramContext:Bool):Void;
    static function trackHomeClick():Void;
    static function trackBoostsClick():Void;
    static function trackCollectionClick():Void;
    static function trackFriendsClick():Void;
    static function trackPlayClick():Void;
    static function trackLvlUpClick():Void;
    static function trackChangeCharacterClick():Void;
    static function trackWalletConnectClick():Void;
    static function trackWalletConnected(address:String):Void;
    static function trackMintRagnarClick():Void;
    static function trackInviteFriendClick():Void;
    static function trackGameStarted():Void;
    static function trackGameWin():Void;
    static function trackGameLose():Void;
}