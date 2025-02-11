package engine.seidh.entity.impl;

import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.CharacterEntityConfig;
import engine.seidh.entity.base.SeidhCharacterEntity;

class ZombieBoyEntity extends SeidhCharacterEntity {

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
                entityType: EntityType.ZOMBIE_BOY,
                entityShape: CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.entityShape,
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.health,
            movement: CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.movement,
            actionMain: CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.actionMain,
        });

        entity.actionMain.actionType = CharacterActionType.ACTION_MAIN;
        entity.movement.canRun = false;

        return entity;
    }
    
}