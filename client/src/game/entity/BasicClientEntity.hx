package game.entity;

abstract class BasicClientEntity<T> extends h2d.Object {

    var engineEntity:T;

    public abstract function update(dt:Float):Void;

    public abstract function debugDraw(graphics:h2d.Graphics):Void;

    public abstract function initiateEngineEntity(engineEntity:T):Void;

}