package engine.holy.entity.factory;

import engine.base.BaseTypesAndClasses.EntityType;
import engine.holy.entity.impl.HolyKnightEntity;
import engine.holy.entity.impl.HolySamuraiEntity;
import engine.holy.entity.impl.HolySkeletonWarriorEntity;
import engine.holy.entity.impl.HolySkeletonArcherEntity;
import engine.holy.entity.base.HolyBaseEntity;

class HolyEntityFactory {

    public static function InitiateEntity(id: String, ownerId: String, x:Int, y:Int, entityType: EntityType) {
        var entity:HolyBaseEntity = null;
        switch (entityType) {
            case KNIGHT:
                entity = new HolyKnightEntity(HolyKnightEntity.GenerateObjectEntity(id, ownerId, x, y));
            case SAMURAI:
                entity = new HolySamuraiEntity(HolySamuraiEntity.GenerateObjectEntity(id, ownerId, x, y));
            case SKELETON_WARRIOR:
                entity = new HolySkeletonWarriorEntity(HolySkeletonWarriorEntity.GenerateObjectEntity(id, ownerId, x, y));
            case SKELETON_ARCHER:
                entity = new HolySkeletonArcherEntity(HolySkeletonArcherEntity.GenerateObjectEntity(id, ownerId, x, y));
            default:
        }
        return entity;
    }

}