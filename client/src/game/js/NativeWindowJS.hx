package game.js;

import engine.base.BaseTypesAndClasses.CharacterActionType;

enum abstract YandexMetricsGoals(String) {
	var JoinSinglePlayerGame = 'JoinSinglePlayerGame';
	var JoinMultiplayerPlayerGame = 'JoinMultiplayerPlayerGame';
}

@:native("window")
extern class NativeWindowJS {

    // Networking
    static function networkInit(playerId:String, wsCallback:Dynamic->Void):Void;
    static function networkFindAndJoinGame(playerId:String):Void;
    static function networkInput(actionType:CharacterActionType, movAngle:Float):Void;

    // Rest
    static function restPostTelegramInitData(telegramInitData:String, startParam:String, callback:Dynamic->Void):Void;

    // Common
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

    // YandexMetrics
    static function ymTrackGoal(goal:YandexMetricsGoals):Void;
}