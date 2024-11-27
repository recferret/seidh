package engine.seidh.entity.impl;

import engine.base.MathUtils;
import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.base.SeidhCharacterEntity;

class ZombieBoyEntity extends SeidhCharacterEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final additionalRndSpeed = MathUtils.randomIntInRange(0, 7);

        var speedFactor = 0;

        switch (additionalRndSpeed) {
            case 0:
                speedFactor = 3;
            case 1:
                speedFactor = 5;
            case 3:
                speedFactor = 7;
            case 4:
                speedFactor = 9;
            case 5:
                speedFactor = 11;
            case 6:
                speedFactor = 13;
            case 7:
                speedFactor = 15;
        }

        final entity = new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.ZOMBIE_BOY,
                entityShape: SeidhGameEngine.CHARACTERS_CONFIG.zombieBoy.entityShape,
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: SeidhGameEngine.CHARACTERS_CONFIG.zombieBoy.health,
            movement: SeidhGameEngine.CHARACTERS_CONFIG.zombieBoy.movement,
            actionMain: SeidhGameEngine.CHARACTERS_CONFIG.zombieBoy.actionMain,
        });

        entity.actionMain.actionType = CharacterActionType.ACTION_MAIN;
        entity.movement.canRun = false;
        entity.movement.runSpeed += additionalRndSpeed;

        return entity;
    }
    
}