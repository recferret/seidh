package engine.seidh.entity.factory;

import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.impl.RagnarLohEntity;
import engine.seidh.entity.impl.RagnarNormEntity;
import engine.seidh.entity.impl.ZombieBoyEntity;
import engine.seidh.entity.impl.ZombieGirlEntity;
import engine.seidh.entity.base.SeidhBaseEntity;

class SeidhEntityFactory {

    public static function InitiateCharacter(id:String, ownerId:String, x:Int, y:Int, entityType:EntityType) {
        var entity:SeidhBaseEntity = null;
        switch (entityType) {
            case RAGNAR_LOH:
                entity = new RagnarLohEntity(RagnarLohEntity.GenerateObjectEntity(id, ownerId, x, y));
            case RAGNAR_NORM:
                entity = new RagnarNormEntity(RagnarNormEntity.GenerateObjectEntity(id, ownerId, x, y));
            case ZOMBIE_BOY:
                entity = new ZombieBoyEntity(ZombieBoyEntity.GenerateObjectEntity(id, ownerId, x, y));
            case ZOMBIE_GIRL:
                entity = new ZombieGirlEntity(ZombieGirlEntity.GenerateObjectEntity(id, ownerId, x, y));
            default:
        }
        return entity;
    }

    public static function InitiateCharacterFromFullStruct(struct:CharacterEntityFullStruct) {
        var entity:SeidhBaseEntity = null;
        switch (struct.base.entityType) {
            case RAGNAR_LOH:
                entity = new RagnarLohEntity(new CharacterEntity(struct));
            case RAGNAR_NORM:
                entity = new RagnarNormEntity(new CharacterEntity(struct));
            case ZOMBIE_BOY:
                entity = new ZombieBoyEntity(new CharacterEntity(struct));
            case ZOMBIE_GIRL:
                entity = new ZombieGirlEntity(new CharacterEntity(struct));
            default:
        }
        return entity;
    }

    public static function InitiateCoin(?id:String, x:Int, y:Int, amount:Int) {
        return new EngineConsumableEntity(new BaseEntity({
            id: id,
            x: x,
            y: y,
            entityType: EntityType.COIN,
            entityShape: {
                width: 50,
                height: 50,
                rectOffsetX: 0,
                rectOffsetY: 0,
            },
        }), amount);
    }

    public static function InitiateHealthPotion(?id:String, x:Int, y:Int, amount:Int) {
        return new EngineConsumableEntity(new BaseEntity({
            id: id,
            x: x,
            y: y,
            entityType: EntityType.HEALTH_POTION,
            entityShape: {
                width: 40,
                height: 60,
                rectOffsetX: 0,
                rectOffsetY: 0,
            },
        }), amount);
    }

    public static function InitiateLosos(?id:String, x:Int, y:Int, amount:Int) {
        return new EngineConsumableEntity(new BaseEntity({
            id: id,
            x: x,
            y: y,
            entityType: EntityType.LOSOS,
            entityShape: {
                width: 80,
                height: 65,
                rectOffsetX: 0,
                rectOffsetY: 0,
            },
        }), amount);
    }

    public static function InitiateProjectile() {
        
    }

}