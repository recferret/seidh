package game.scene.home;

abstract class BasicHomeContent extends h2d.Object {

    public var contentScrollY = 0.0;

    public abstract function update(dt:Float):Void;
}