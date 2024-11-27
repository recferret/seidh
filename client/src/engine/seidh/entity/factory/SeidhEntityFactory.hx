package engine.seidh.entity.factory;

import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.impl.RagnarLohEntity;
import engine.seidh.entity.impl.ZombieBoyEntity;
import engine.seidh.entity.impl.ZombieGirlEntity;
import engine.seidh.entity.base.SeidhCharacterEntity;

class SeidhEntityFactory {

    public static function InitiateCharacter(struct:CharacterEntityMinStruct) {
        var entity:SeidhCharacterEntity = null;
        switch (struct.entityType) {
            case RAGNAR_LOH:
                entity = new RagnarLohEntity(RagnarLohEntity.GenerateObjectEntity(struct));
            case ZOMBIE_BOY:
                entity = new ZombieBoyEntity(ZombieBoyEntity.GenerateObjectEntity(struct));
            case ZOMBIE_GIRL:
                entity = new ZombieGirlEntity(ZombieGirlEntity.GenerateObjectEntity(struct));
            default:
        }
        return entity;
    }

    public static function InitiateCharacterFromFullStruct(struct:CharacterEntityFullStruct) {
        var entity:SeidhCharacterEntity = null;
        switch (struct.base.entityType) {
            case RAGNAR_LOH:
                entity = new RagnarLohEntity(new CharacterEntity(struct));
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
                rectOffsetY: 40,
                radius: 0,
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
                radius: 0,
            },
        }), amount);
    }

    public static function InitiateSalmon(?id:String, x:Int, y:Int, amount:Int) {
        return new EngineConsumableEntity(new BaseEntity({
            id: id,
            x: x,
            y: y,
            entityType: EntityType.SALMON,
            entityShape: {
                width: 80,
                height: 65,
                rectOffsetX: 0,
                rectOffsetY: 0,
                radius: 0,
            },
        }), amount);
    }

    public static function InitiateProjectile() {
        
    }

}