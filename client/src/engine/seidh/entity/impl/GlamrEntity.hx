package engine.seidh.entity.impl;

import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.CharacterEntityConfig;
import engine.seidh.entity.base.SeidhCharacterEntity;

class GlamrEntity extends SeidhCharacterEntity {

    public final monstersToSpawnByDefault = 20;
    public var monstersToSpawn = 0;

    private final maxMonsters = 40;
    private var monstersSpawned = 0;
    private var currentPhase = 1;

    public function new(characterEntity:CharacterEntity) {
        super(characterEntity);
    }

    public function absUpdate(dt:Float) {
        if (actionState == CharacterActionState.READY) {
            if (characterEntity.health <= (maxHealth / 100) * 70 && currentPhase == 1) {
                currentPhase = 2;
            }

            aiLookAtTarget();

            if (currentPhase == 1) {
                aiFollowAndAttack();
            }

            if (currentPhase == 2) {
                if (monstersSpawned < maxMonsters) {
                    monstersToSpawn = maxMonsters - monstersSpawned;
                    if (monstersToSpawn > monstersToSpawnByDefault) {
                        monstersToSpawn = monstersToSpawnByDefault;
                    }
                    aiApplyAction1();
                }
                aiFollowAndAttack();
            }
        }
    }

    public function monsterSpawned() {
        monstersSpawned += 1;
    }

    public function monsterKilled() {
        monstersSpawned -= 1;
    }

    // ------------------------------------------------
	// Dummy stats hardcode instead of database
	// ------------------------------------------------

    public static function GenerateObjectEntity(struct:CharacterEntityMinStruct) {
        final entity = new CharacterEntity({
            base: {
                x: struct.x, 
                y: struct.y,
                entityType: EntityType.GLAMR,
                entityShape: CharacterEntityConfig.CHARACTERS_CONFIG.glamr.entityShape,
                id: struct.id,
                ownerId: struct.ownerId,
                rotation: 0
            },
            health: CharacterEntityConfig.CHARACTERS_CONFIG.glamr.health,
            movement: CharacterEntityConfig.CHARACTERS_CONFIG.glamr.movement,
            actionMain: CharacterEntityConfig.CHARACTERS_CONFIG.glamr.actionMain,
            action1: CharacterEntityConfig.CHARACTERS_CONFIG.glamr.action1,
            action2: CharacterEntityConfig.CHARACTERS_CONFIG.glamr.action2,
        });

        entity.actionMain.actionType = CharacterActionType.ACTION_MAIN;
        entity.action1.actionType = CharacterActionType.ACTION_1;
        entity.movement.canRun = false;

        return entity;
    }
    
}