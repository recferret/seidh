package game.entity.character;

import engine.base.entity.impl.EngineCharacterEntity;

class ClientCharacterFactory {

    public static function InitiateCharacter(s2d:h2d.Scene, engineEntity:EngineCharacterEntity) {
        var entity:ClientCharacterEntity = null;
        switch (engineEntity.getEntityType()) {
            case RAGNAR_LOH:
                entity = new ClientCharacterRagnarLoh(s2d, engineEntity);
            case RAGNAR_BEAST:
                entity = new ClientCharacterRagnarBeast(s2d, engineEntity);
            case ZOMBIE_BOY:
                entity = new ClientCharacterZombieBoy(s2d, engineEntity);
            case ZOMBIE_GIRL:
                entity = new ClientCharacterZombieGirl(s2d, engineEntity);
            case GLAMR:
                entity = new ClientCharacterGlamr(s2d, engineEntity);
            default:
        }
        return entity;
    }

}