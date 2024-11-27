package engine.seidh.entity.impl;

import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.base.SeidhCharacterEntity;

class RagnarLohEntity extends SeidhCharacterEntity {

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final entity = new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.RAGNAR_LOH,
                entityShape: SeidhGameEngine.CHARACTERS_CONFIG.ragnarLoh.entityShape,
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: SeidhGameEngine.CHARACTERS_CONFIG.ragnarLoh.health,
            movement: SeidhGameEngine.CHARACTERS_CONFIG.ragnarLoh.movement,
            actionMain: SeidhGameEngine.CHARACTERS_CONFIG.ragnarLoh.actionMain,
        });
        entity.actionMain.actionType = CharacterActionType.ACTION_MAIN;
        return entity;
    }
    
}