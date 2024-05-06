package engine.seidh.entity.factory;

import engine.base.BaseTypesAndClasses.EntityType;
import engine.seidh.entity.impl.SeidhKnightEntity;
// import engine.seidh.entity.impl.SeidhSamuraiEntity;
import engine.seidh.entity.impl.SeidhSkeletonWarriorEntity;
// import engine.seidh.entity.impl.SeidhSkeletonArcherEntity;
import engine.seidh.entity.base.SeidhBaseEntity;

class SeidhEntityFactory {

    public static function InitiateEntity(id: String, ownerId: String, x:Int, y:Int, entityType: EntityType) {
        var entity:SeidhBaseEntity = null;
        switch (entityType) {
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

}