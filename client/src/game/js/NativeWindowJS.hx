package game.js;

@:native("window")
extern class NativeWindowJS {
	static function wsConnect(callback:String->Void):Void;
    static function wtConnect(callback:String->Void):Void;

    static function wsSend(message:Dynamic):Void;
    static function wtSend(message:Dynamic):Void;

    static function tgExpand():Void;
}