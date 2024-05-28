package engine.seidh.entity.factory;

import engine.base.BaseTypesAndClasses;
import engine.seidh.entity.impl.RagnarEntity;
import engine.seidh.entity.impl.SeidhKnightEntity;
import engine.seidh.entity.impl.SeidhSkeletonWarriorEntity;
import engine.seidh.entity.base.SeidhBaseEntity;

class SeidhEntityFactory {

    public static function InitiateEntity(id: String, ownerId: String, x:Int, y:Int, entityType: EntityType) {
        var entity:SeidhBaseEntity = null;
        switch (entityType) {
            case RAGNAR:
                entity = new RagnarEntity(RagnarEntity.GenerateObjectEntity(id, ownerId, x, y));
            case KNIGHT:
                entity = new SeidhKnightEntity(SeidhKnightEntity.GenerateObjectEntity(id, ownerId, x, y));
            // case SAMURAI:
                // entity = new SeidhSamuraiEntity(SeidhSamuraiEntity.GenerateObjectEntity(id, ownerId, x, y));
            case SKELETON_WARRIOR:
                entity = new SeidhSkeletonWarriorEntity(SeidhSkeletonWarriorEntity.GenerateObjectEntity(id, ownerId, x, y));
            // case SKELETON_ARCHER:
                // entity = new SeidhSkeletonArcherEntity(SeidhSkeletonArcherEntity.GenerateObjectEntity(id, ownerId, x, y));
            default:
        }
        return entity;
    }

    public static function InitiateCharacterFromFullStruct(struct:CharacterEntityFullStruct) {
        var entity:SeidhBaseEntity = null;

        switch (struct.base.entityType) {
            case RAGNAR:
                entity = new RagnarEntity(new CharacterEntity(struct));
            case KNIGHT:
                entity = new SeidhKnightEntity(new CharacterEntity(struct));
            case SKELETON_WARRIOR:
                entity = new SeidhSkeletonWarriorEntity(new CharacterEntity(struct));
            default:
        }
        return entity;
    }

    public static function InitiateProjectile() {
        
    }

}