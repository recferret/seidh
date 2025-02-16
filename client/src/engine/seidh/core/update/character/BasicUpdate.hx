package engine.seidh.core.update.character;

import engine.base.entity.base.EngineBaseEntity;

abstract class BasicUpdate {

    final allowServerLogic:Bool;

    public function new(allowServerLogic:Bool) {
        this.allowServerLogic = allowServerLogic;
    }

    abstract function absUpdate(dt:Float, characters:Array<EngineBaseEntity>):Void;

    function getNearestPlayer(characters:Array<EngineBaseEntity>, entity:EngineBaseEntity) {
        var nearestPlayer:EngineBaseEntity = null;
        var nearestPlayerDistance:Float = 0.0;

        for (character in characters) {
            if (character.isPlayer()) {
                final dist = entity.getBodyRectangle().getCenter().distance(character.getBodyRectangle().getCenter());
                if (nearestPlayer == null || dist < nearestPlayerDistance) {
                    nearestPlayer = character;
                    nearestPlayerDistance = dist;
                }
            }
        }

        return nearestPlayer;
    }

}