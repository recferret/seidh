package engine.seidh.entity.impl;

import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.CharacterEntityConfig;
import engine.seidh.entity.base.SeidhCharacterEntity;

class ZombieGirlEntity extends SeidhCharacterEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    public function absUpdate(dt:Float) {
        aiLookAtTarget();
        aiFollowAndAttack();
    }
    
    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final entity = new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.ZOMBIE_GIRL,
                entityShape: CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.entityShape,
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.health,
            movement: CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.movement,
            actionMain: CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.actionMain,
        });

        entity.actionMain.actionType = CharacterActionType.ACTION_MAIN;
        entity.movement.canRun = false;

        return entity;
    }

}