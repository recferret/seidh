package engine.seidh.entity.impl;

import engine.base.MathUtils;
import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.base.SeidhCharacterEntity;

class ZombieGirlEntity extends SeidhCharacterEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final additionalRndSpeed = MathUtils.randomIntInRange(0, 7);
        var speedFactor = 10;

        switch (additionalRndSpeed) {
            case 0:
                speedFactor = 6;
            case 1:
                speedFactor = 7;
            case 3:
                speedFactor = 8;
            case 4:
                speedFactor = 9;
            case 5:
                speedFactor = 10;
            case 6:
                speedFactor = 11;
            case 7:
                speedFactor = 12;
        }

        final entity = new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.ZOMBIE_GIRL,
                entityShape: SeidhGameEngine.CHARACTERS_CONFIG.zombieGirl.entityShape,
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: SeidhGameEngine.CHARACTERS_CONFIG.zombieGirl.health,
            movement: SeidhGameEngine.CHARACTERS_CONFIG.zombieGirl.movement,
            actionMain: SeidhGameEngine.CHARACTERS_CONFIG.zombieGirl.actionMain,
        });

        entity.actionMain.actionType = CharacterActionType.ACTION_MAIN;
        entity.movement.canRun = false;
        entity.movement.runSpeed += additionalRndSpeed;

        return entity;
    }
    
}