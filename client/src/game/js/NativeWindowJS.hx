package game.js;

enum abstract YandexMetricsGoals(String) {
	var JoinSinglePlayerGame = 'JoinSinglePlayerGame';
	var JoinMultiplayerPlayerGame = 'JoinMultiplayerPlayerGame';
}

@:native("window")
extern class NativeWindowJS {

    // WS
	static function wsConnect(callback:String->Void):Void;
    static function wsSend(message:Dynamic):Void;

    // HTTP

    // Common
    static function getMobile():String;
    static function getScreenParams():Dynamic;
    static function alertScreenParams():Void;

    // Telegram
    static function tgExpand():Void;

    // YandexMetrics
    static function ymTrackGoal(goal:YandexMetricsGoals):Void;
}