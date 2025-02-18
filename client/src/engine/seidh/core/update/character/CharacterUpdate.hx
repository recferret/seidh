package engine.seidh.core.update.character;

import engine.base.types.TypesBaseEntity.EntityType;
import engine.base.types.TypesBaseEntity.CharacterActionType;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.geometry.Line;
import engine.base.types.TypesBaseEntity.CharacterActionEffect;
import engine.base.types.TypesBaseEntity.CharacterActionCallbackParams;
import engine.base.types.TypesBaseEntity.CharacterActionState;

typedef PickedUpConsumable = {
    consumableId:String,
    characterId:String,
};

typedef CreateProjectileCallbackParams = {
    characterId:String,
};

typedef CharacterKilledCallbackParams = {
    characterId:String,
    ownerId:String,
    killerCharacterId:String,
    killerOwnerId:String,
};

typedef SummonCallbackParams = {
    characterId:String,
};

class CharacterUpdate extends BasicUpdate {

    private final lineColliders = new Array<Line>();

    private var characters:Array<EngineBaseEntity>;
    private var projectiles:Array<EngineBaseEntity>;
    private var consumables:Array<EngineBaseEntity>;

    // Action callbacks
    private var consumablePickUpCallback:Array<PickedUpConsumable>->Void;
    private var characterActionCallback:Array<CharacterActionCallbackParams>->Void;
    private var createProjectileCallback:CreateProjectileCallbackParams->Void;
    private var playerKilledCallback:CharacterKilledCallbackParams->Void;
    private var monsterKilledCallback:CharacterKilledCallbackParams->Void;
    private var bossKilledCallback:CharacterKilledCallbackParams->Void;
    private var summonCallback:SummonCallbackParams->Void;

    private var actionCallbacksDuringTick = new Array<CharacterActionCallbackParams>();
    private var pickedUpConsumablesDuringTick = new Array<PickedUpConsumable>();

    public function new(allowServerLogic:Bool, lineColliders:Array<Line>) {
        super(allowServerLogic);

        this.lineColliders = lineColliders;
    }

    // ------------------------------------
    // Callbacks
    // ------------------------------------

    public function setConsumablePickUpCallback(consumablePickUpCallback:Array<PickedUpConsumable>->Void) {
        this.consumablePickUpCallback = consumablePickUpCallback;
    }

    public function setCharacterActionCallback(characterActionCallback:Array<CharacterActionCallbackParams>->Void) {
        this.characterActionCallback = characterActionCallback;
    }

    public function setCreateProjectileCallback(createProjectileCallback:CreateProjectileCallbackParams->Void) {
        this.createProjectileCallback = createProjectileCallback;
    }

    public function setPlayerKilledCallback(playerKilledCallback:CharacterKilledCallbackParams->Void) {
        this.playerKilledCallback = playerKilledCallback;
    }

    public function setMonsterKilledCallback(monsterKilledCallback:CharacterKilledCallbackParams->Void) {
        this.monsterKilledCallback = monsterKilledCallback;
    }

    public function setBossKilledCallback(bossKilledCallback:CharacterKilledCallbackParams->Void) {
        this.bossKilledCallback = bossKilledCallback;
    }

    public function setSummonCallback(summonCallback:SummonCallbackParams->Void) {
        this.summonCallback = summonCallback;
    }

    // ------------------------------------

    public function update(
        dt:Float,
        characters:Array<EngineBaseEntity>,
        projectiles:Array<EngineBaseEntity>,
        consumables:Array<EngineBaseEntity>
    ) {
        this.characters = characters;
        this.projectiles = projectiles;
        this.consumables = consumables;

        absUpdate(dt, characters);
    }

    function absUpdate(dt:Float, characters:Array<EngineBaseEntity>) {
        for (c in characters) {
            final character = cast(c, EngineCharacterEntity);

            if (character.isAlive) {
                character.update(dt);

                if (character.isPlayer()) {
                    playerPickUpConsumables(character);
                    playerRestrictMovement(character);
                }

                characterToProjectilesCollision(character);
                performCharacterAction(character);
            }
        }

        characterActionCallback(actionCallbacksDuringTick);
        consumablePickUpCallback(pickedUpConsumablesDuringTick);

        actionCallbacksDuringTick = new Array<CharacterActionCallbackParams>();
        pickedUpConsumablesDuringTick = new Array<PickedUpConsumable>();
    }

    private function characterToProjectilesCollision(character:EngineCharacterEntity) {
        for (p in projectiles) {
            final projectile = cast(p, EngineProjectileEntity);

            final hurtEntities = new Array<String>();
            final deadEntities = new Array<String>();

            if (projectile.getOwnerId() != character.getOwnerId()) {
                final damage = projectile.getDamage();
                final projectileRect = projectile.getBodyRectangle();
                final characterRect = character.getBodyRectangle();

                if (projectileRect.getCenter().distance(characterRect.getCenter()) < characterRect.w) {
                    final projectileHitsCharacter = projectile.getBodyRectangle().containsRect(character.getBodyRectangle());
                    if  (projectileHitsCharacter && !character.wasHitByProjectile(projectile.getId())) {
                        character.hitByProjectile(projectile.getId());

                        final health = subtractHealthFromCharacter(character, damage, null, projectile.getOwnerId());
                        if (health == 0) {
                            deadEntities.push(character.getId());
                        } else {
                            hurtEntities.push(character.getId());
                        }
                    }
                }

                final callbackParams:CharacterActionCallbackParams = {
                    entityId: character.getId(),
                    damage: damage,
                    actionType: CharacterActionType.ACTION_MAIN,
                    actionEffect: CharacterActionEffect.RANGE_ATTACK,
                    playActionAnim: false,
                    playEffectAnim: false,
                    hurtEntities: hurtEntities,
                    deadEntities: deadEntities,
                };
        
                actionCallbacksDuringTick.push(callbackParams);
            }
        }
    }

    private function performCharacterAction(character:EngineCharacterEntity) {
        if (character.actionState == CharacterActionState.IN_QUEUE) {
            character.actionState = CharacterActionState.IN_PROGRESS;

            final callbackParams:CharacterActionCallbackParams = {
                entityId: character.getId(),
                actionType: character.actionToPerform.actionType,
                actionEffect: character.actionToPerform.actionEffect,
                playActionAnim: false,
                playEffectAnim: false,
            };

            if (character.actionToPerform.performDelayMs == 0) {
                instantAction(character, callbackParams);
            } else {
                delayedAction(character, callbackParams);
            }
        }

    }

    private function performAction(character:EngineCharacterEntity, callbackParams:CharacterActionCallbackParams) {
        if (character.actionToPerform.actionEffect == CharacterActionEffect.MELEE_ATTACK) {
            final hurtEntities = new Array<String>();
            final deadEntities = new Array<String>();

            final actionShape = character.actionToPerform.meleeStruct.shape;
            final damage = character.actionToPerform.meleeStruct.damage;

            for (c in characters) {
                final character2 = cast(c, EngineCharacterEntity);

                if (character2.isAlive && character.getId() != character2.getId()) {
                    final characterHasActionRect = character.getActionRect(true) != null;
                    final characterHitsAnother = character.getActionRect(true).containsRect(character2.getBodyRectangle()); 
                    final skipBotToBotAttack = !character.isPlayer() && !character2.isPlayer();

                    if (characterHasActionRect && characterHitsAnother && !skipBotToBotAttack) {
                        final health = subtractHealthFromCharacter(character2, damage, character.getId(), character.getOwnerId());
                        if (health == 0) {
                            deadEntities.push(character2.getId());
                        } else {
                            hurtEntities.push(character2.getId());
                        }
                    }
                }
            }

            callbackParams.shape = actionShape;
            callbackParams.damage = damage;
            callbackParams.hurtEntities = hurtEntities;
            callbackParams.deadEntities = deadEntities;

            character.actionToPerform = null;
            actionCallbacksDuringTick.push(callbackParams);
        } else

        if (character.actionToPerform.actionEffect == CharacterActionEffect.RANGE_ATTACK) {
            if (createProjectileCallback != null) {
                createProjectileCallback({
                    characterId: character.getId(),
                });
            }

            character.actionToPerform = null;
            actionCallbacksDuringTick.push(callbackParams);
        } else 

        if (character.actionToPerform.actionEffect == CharacterActionEffect.SUMMON) {
            haxe.Timer.delay(function callback() {
                summonCallback({
                    characterId: character.getId(),
                });

                if (character.actionToPerform.postDelayMs != 0) {
                    haxe.Timer.delay(function callback() {
                        character.canChangeState = true;
                        character.actionState = CharacterActionState.READY;
                        character.actionToPerform = null;
                    }, character.actionToPerform.postDelayMs);
                } else {
                    character.canChangeState = true;
                    character.actionState = CharacterActionState.READY;
                    character.actionToPerform = null;
                }
        
                callbackParams.playActionAnim = true;
                actionCallbacksDuringTick.push(callbackParams);
            }, character.actionToPerform.performDelayMs);
        }
    }

    private function subtractHealthFromCharacter(character:EngineCharacterEntity, damage:Int, killerCharacterId:String, killerOwnerId:String) {
        final health = character.subtractHealth(damage);
        if (health == 0) {
            if (character.isPlayer()) {
                if (playerKilledCallback != null) {
                    playerKilledCallback({
                        characterId: character.getId(),
                        ownerId: character.getOwnerId(),
                        killerCharacterId: killerCharacterId,
                        killerOwnerId: killerOwnerId,
                    });
                }
            }

            if (character.isBoss()) {
                if (bossKilledCallback != null) {
                    bossKilledCallback({
                        characterId: character.getId(),
                        ownerId: character.getOwnerId(),
                        killerCharacterId: killerCharacterId,
                        killerOwnerId: killerOwnerId,
                    });
                }
            }

            if (character.isMonster()) {
                if (monsterKilledCallback != null) {
                    monsterKilledCallback({
                        characterId: character.getId(),
                        ownerId: character.getOwnerId(),
                        killerCharacterId: killerCharacterId,
                        killerOwnerId: killerOwnerId,
                    });
                }
            }

            character.isAlive = false;
        }

        return health;
    }

    private function instantAction(character:EngineCharacterEntity, callbackParams:CharacterActionCallbackParams) {
        character.canChangeState = true;
        character.actionState = CharacterActionState.READY;

        callbackParams.playActionAnim = true;
        callbackParams.playEffectAnim = true;

        performAction(character, callbackParams);
    }

    private function delayedAction(character:EngineCharacterEntity, callbackParams:CharacterActionCallbackParams) {
        callbackParams.playActionAnim = true;

        actionCallbacksDuringTick.push(callbackParams);
        
        haxe.Timer.delay(function callback() {
            character.canChangeState = true;
            character.actionState = CharacterActionState.READY;
            
            callbackParams.playEffectAnim = true;
            
            performAction(character, callbackParams);
        }, character.actionToPerform.performDelayMs);
    }

    private function playerPickUpConsumables(character:EngineCharacterEntity) {
        for (c in consumables) {
            final consumable = cast(c, EngineConsumableEntity);
            final characterPickUpCircle = character.getBodyCircle();

            if (characterPickUpCircle.getCenter().distance(consumable.getBodyRectangle().getCenter()) < characterPickUpCircle.r + 10) {
                if (characterPickUpCircle.containsRect(consumable.getBodyRectangle())) {
                    pickedUpConsumablesDuringTick.push({
                        consumableId: consumable.getId(),
                        characterId: character.getId(),
                    });
                }
            }
        }

    }

    private function playerRestrictMovement(character:EngineCharacterEntity) {
        var intersectsWithLine = false;
        for (line in lineColliders) {
            if (character.getForwardLookingLine(character.playerForwardLookingLineLength).intersectsWithLine(line)) {
                intersectsWithLine = true;
                break;
            }
        }

        if (intersectsWithLine) {
            character.canMove = false;
        } else {
            character.canMove = true;
        }
    }
}