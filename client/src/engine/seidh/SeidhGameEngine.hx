package engine.seidh;

import engine.seidh.entity.impl.GlamrEntity;
import engine.base.geometry.Point;
import js.lib.Date;

import engine.base.EngineConfig;
import engine.base.MathUtils;
import engine.base.entity.base.EngineBaseEntity;
import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.core.BaseEngine;
import engine.base.types.TypesBaseEngine;
import engine.base.types.TypesBaseEntity;
import engine.base.types.TypesBaseMultiplayer;

import engine.seidh.entity.base.SeidhCharacterEntity;
import engine.seidh.entity.factory.SeidhEntityFactory;
import engine.seidh.types.TypesSeidhGame;

@:expose
class SeidhGameEngine extends BaseEngine {

    public static final GameWorldSize = 5000;

    public static final GAME_CONFIG:GameConfig = {
        // Monsters spawn
	    monstersMaxAtTheSameTime: 1,
        monstersMaxPerGame: 0,
        monstersSpawnDelayMs: 0,

        // Exp boost
        expLevel1Multiplier: 1.5,
        expLevel2Multiplier: 2,
        expLevel3Multiplier: 3,

        // Stats boost
        statsLevel1Multiplier: 1.2,
        statsLevel2Multiplier: 1.5,
        statsLevel3Multiplier: 2,

        // Wealth boost
        wealthLevel1PickUpRangeMultiplier: 1.5,
        wealthLevel2PickUpRangeMultiplier: 2,
        wealthLevel3PickUpRangeMultiplier: 2.5,

        wealthLevel1CoinsMultiplier: 2,
        wealthLevel2CoinsMultiplier: 3,
        wealthLevel3CoinsMultiplier: 4,
    };

    private var lastDt = 0.0;
    private var framesPassed = 0;
    private var timePassed = 0.0;
    private var msPassed = 0;
    private var secondsPassed = 0;
    private final secondsToSurvive = 60;

    private var winCondition:WinCondition;
    private var gameStage = GameStage.KILL_MONSTERS;

    private final aiManager:AiManager;

    private var glamr:GlamrEntity;

    private final playerZombiesKilled = new Map<String, Int>();
    private final playerCoinsGained = new Map<String, Int>();
    private final lineColliders = new Array<engine.base.geometry.Line>();

    public var gameId:String;

    public var characterActionCallbacks:Array<CharacterActionCallbackParams>->Void;
    public var gameStateCallback:GameState->Void;
    public var gameStageCallback:GameStage->Void;
    public var oneSecondCallback:Void->Void;
    
    public final playersSpawnPoints = [
        new Point(2500, 2500)
    ];

    public static function main() {}

    public function new(engineMode:EngineMode, winCondition:WinCondition = WinCondition.INFINITE) {
	    super(engineMode);

        aiManager = new AiManager(winCondition);

        this.winCondition = winCondition;

		addLineCollider(0, 0, GameWorldSize, 0);
		addLineCollider(0, GameWorldSize, GameWorldSize, GameWorldSize);
		addLineCollider(0, 0, 0, GameWorldSize);
		addLineCollider(GameWorldSize, 0, GameWorldSize, GameWorldSize);

        oneTenthOfASecondTimer();

        // createConsumable(struct.x + 300, struct.y);
        // createConsumable(struct.x + 400, struct.y);
        // createConsumable(struct.x + 500, struct.y);
        // createConsumable(struct.x + 600, struct.y);
        // createConsumable(struct.x + 700, struct.y);
    }

    // ---------------------------------------------------
    // Create entity helpers
    // ---------------------------------------------------

    public function createCharacterEntityFromMinimalStruct(struct:CharacterEntityMinStruct) {
        addToCharacterCreateQueue(SeidhEntityFactory.InitiateCharacter(struct));
    }

    public function createCharacterEntityFromFullStruct(struct:CharacterEntityFullStruct) {
        addToCharacterCreateQueue(SeidhEntityFactory.InitiateCharacterFromFullStruct(struct));
    }

    // ---------------------------------------------------
    // Abstract implementation
    // ---------------------------------------------------

    public function processInputCommands(playerInputCommands:Array<InputCommandEngineWrapped>) {
        for (i in playerInputCommands) {
			final input = cast(i.playerInputCommand, PlayerInputCommand);
			final inputInitiator = input.userId;
			final entityId = playerToEntityMap.get(inputInitiator);
			final entity = cast(characterEntityManager.getEntityById(entityId), SeidhCharacterEntity);

			if (entity == null || entity.getOwnerId() != inputInitiator) {
				continue;
			}
        
            // Server request queue
			validatedInputCommands.push(input);

            if (input.actionType == CharacterActionType.MOVE) {
                entity.performMove(input);
            } else {
                entity.setNextActionToPerform(input.actionType);
            }
		}
    }

    public function engineLoopUpdate(dt:Float) {
        lastDt = dt;

        if (gameState == GameState.PLAYING) {
            final beginTime = Date.now();

            framesPassed++;
            timePassed += dt;

            final characterActionCallbackParams = new Array<CharacterActionCallbackParams>();

            for (e in projectileEntityManager.entities) {
                final projectile = cast(e, EngineProjectileEntity);

                if (projectile.allowMovement) {
                    projectile.update(dt);
                } else {
                    addToProjectileDeleteQueue(projectile.getId());
                }
            }

            // AI
            final allowServerLogic = engineMode == EngineMode.SERVER || engineMode == EngineMode.CLIENT_SINGLEPLAYER;

            if (allowServerLogic && EngineConfig.AI_ENABLED) {
                for (e1 in characterEntityManager.entities) {
                    final character1 = cast(e1, EngineCharacterEntity);
                    
                    if (character1.isAlive && !character1.isPlayer()) {
                        // Find and set nearest player as a target
                        final targetPlayer = getNearestPlayer(character1);
                        if (targetPlayer != null && character1.getTargetObject() != targetPlayer) {
                            character1.setTargetObject(targetPlayer, true);
                        } else {
                            character1.clearTargetObject();
                        }

                        // Restrict movement through objects
                        for (e2 in characterEntityManager.entities) {
                            final character2 = cast(e2, EngineCharacterEntity);
                            if (!character1.intersectsWithCharacter && character1.getId() != character2.getId() && character2.isAlive && !character2.isPlayer()) {
                                if (character2.getBodyRectangle().intersectsWithLine(character1.botForwardLookingLine)) {
                                    character1.intersectsWithCharacter = true;
                                    character1.canMove = false;
                                }
                            }
                        }

                        character1.intersectsWithCharacter = false;
                        character1.canMove = true;
                    }
                }
            }

            for (e in characterEntityManager.entities) {
                final character1 = cast(e, EngineCharacterEntity);
                final character1Id = character1.getId();
                final character1OwnerId = character1.getOwnerId();

                if (character1.getEntityType() == EntityType.GLAMR && glamr == null) {
                    glamr = cast(character1, GlamrEntity);
                }

                if (character1.isAlive) {
                    character1.update(dt);

                    if (character1.isPlayer()) {
                        for (c in consumableEntityManager.entities) {
                            final consumable = cast(c, EngineConsumableEntity);

                            // Pick up items
                            final characterPickUpCircle = character1.getBodyCircle();
                            if (characterPickUpCircle.getCenter().distance(consumable.getBodyRectangle().getCenter()) < characterPickUpCircle.r + 10) {
                                if (characterPickUpCircle.containsRect(consumable.getBodyRectangle())) {
                                    if (consumable.getEntityType() == EntityType.COIN) {
                                        // Increase coins accquired
                                        final coinsGained = playerCoinsGained.get(character1OwnerId);
                                        if (coinsGained != null) {
                                            playerCoinsGained.set(character1OwnerId, coinsGained + 1);
                                        } else {
                                            playerCoinsGained.set(character1OwnerId, 1);
                                        }
                                    } else {
                                        // Give health
                                        character1.addHealth(consumable.amount);
                                    }

                                    addToConsumableDeleteQueue(consumable.getId(), character1Id);
                                }
                            }
                        }

                        // Restrict border movement
                        var intersectsWithLine = false;
                        for (line in lineColliders) {
                            if (character1.getForwardLookingLine(character1.playerForwardLookingLineLength).intersectsWithLine(line)) {
                                intersectsWithLine = true;
                                break;
                            }
                        }

                        if (intersectsWithLine) {
                            character1.canMove = false;
                        } else {
                            character1.canMove = true;
                        }
                    }

                    // Check projectile collisions against characters
                    for (e in projectileEntityManager.entities) {
                        final projectile = cast(e, EngineProjectileEntity);

                        // Skip self collision
                        if (projectile.getOwnerId() != character1OwnerId) {
                            final projectileRect = projectile.getBodyRectangle();
                            final characterRect = character1.getBodyRectangle();

                            // Skip far collisions
                            if (projectileRect.getCenter().distance(characterRect.getCenter()) < characterRect.w) {
                                // TODO hit by projectile
                                // TODO rename allowMovement
                                projectile.allowMovement = false;
                            }
                        }
                    }

                    // Perform character action
                    if (character1.actionState == CharacterActionState.IN_QUEUE) {
                        character1.actionState = CharacterActionState.IN_PROGRESS;

                        final callbackParams:CharacterActionCallbackParams = {
                            entityId: character1.getId(),
                            actionType: character1.actionToPerform.actionType,
                            actionEffect: character1.actionToPerform.actionEffect,
                            playActionAnim: false,
                            playEffectAnim: false,
                        };

                        if (character1.actionToPerform.actionEffect == CharacterActionEffect.ATTACK) {
                            function performAttack() {                               
                                final hurtEntities = new Array<String>();
                                final deadEntities = new Array<String>();

                                var actionShape:ShapeStruct = null;
                                if (character1.actionToPerform.projectileStruct != null) {
                                    addToProjectileCreateQueue(createProjectileByCharacter(character1));
                                    actionShape = character1.actionToPerform.projectileStruct.shape;
                                } else if (character1.actionToPerform.meleeStruct != null) {
                                    actionShape = character1.actionToPerform.meleeStruct.shape;
                                }

                                for (e2 in characterEntityManager.entities) {
                                    final character2 = cast(e2, EngineCharacterEntity);
                                    // TODO add distance check here
                                    if (character2.isAlive && character1Id != character2.getId()) {
                                        final characterHasActionRect = character1.getActionRect(true) != null;
                                        final chatacterHitsAnother = character1.getActionRect(true).containsRect(character2.getBodyRectangle()); 
                                        final skipBotToBotAttack = !character1.isPlayer() && !character2.isPlayer();
                                        if (characterHasActionRect && chatacterHitsAnother && !skipBotToBotAttack) {
                                            if (allowServerLogic) {
                                                final health = character2.subtractHealth(character1.actionToPerform.damage);
                                                if (health == 0) {
                                                    if (character2.isPlayer() && character2.getOwnerId() == localPlayerId) {
                                                        setGameState(GameState.LOSE);
                                                    }

                                                    if (character2.isBoss()) {
                                                        aiManager.setBossKilled();
                                                    }

                                                    if (character2.isMonster()) {
                                                        aiManager.monsterKilled();

                                                        if (glamr != null) {
                                                            glamr.monsterKilled();
                                                        }

                                                        // Update player kills
                                                        final zombieKills = playerZombiesKilled.get(character1OwnerId);
                                                        if (zombieKills != null) {
                                                            playerZombiesKilled.set(character1OwnerId, zombieKills + 1);
                                                        } else {
                                                            playerZombiesKilled.set(character1OwnerId, 1);
                                                        }

                                                        createRandomConsumable(
                                                            Std.int(character2.getBodyRectangle().x), 
                                                            Std.int(character2.getBodyRectangle().y),
                                                        );
                                                    }

                                                    character2.isAlive = false;
                                                    deadEntities.push(character2.getId());
                                                    addToCharacterDeleteQueue(character2.getId());
                                                } else {
                                                    hurtEntities.push(character2.getId());
                                                }
                                            } else {
                                                hurtEntities.push(character2.getId());
                                            }
                                        }
                                    }

                                    callbackParams.shape = actionShape;
                                    callbackParams.damage = character1.actionToPerform.damage;
                                    callbackParams.hurtEntities = hurtEntities;
                                    callbackParams.deadEntities = deadEntities;
                                }
                            }

                            if (character1.actionToPerform.performDelayMs == 0) {
                                performAttack();

                                character1.canChangeState = true;
                                character1.actionState = CharacterActionState.READY;
                                character1.actionToPerform = null;

                                callbackParams.playActionAnim = true;
                                callbackParams.playEffectAnim = true;

                                characterActionCallbackParams.push(callbackParams);
                            } else {
                                // Visuals only
                                callbackParams.playActionAnim = true;
                                sendCharacterActionCallbacks([callbackParams]);

                                // Action itself
                                haxe.Timer.delay(function callback() {
                                    performAttack();
        
                                    character1.canChangeState = true;
                                    character1.actionState = CharacterActionState.READY;
                                    character1.actionToPerform = null;
        
                                    callbackParams.playEffectAnim = true;
                                    sendCharacterActionCallbacks([callbackParams]);
                                }, character1.actionToPerform.performDelayMs);
                            }
                        } else if (character1.actionToPerform.actionEffect == CharacterActionEffect.SUMMON) {
                            if (character1.getEntityType() == GLAMR) {
                                haxe.Timer.delay(function callback() {
                                    final glamr = cast(character1, GlamrEntity);
                                    final monsters = aiManager.spawnMonstersAroundPoint(character1.getX(), character1.getY(), glamr.monstersToSpawn);
                                    for (monster in monsters) {
                                        addToCharacterCreateQueue(SeidhEntityFactory.InitiateCharacter(
                                            {
                                                x: monster.positionX,
                                                y: monster.positionY,
                                                entityType: monster.entityType,
                                            }
                                        ));
                                        glamr.monsterSpawned();
                                    }

                                    // TODO Refactor how actions are working
                                    if (character1.actionToPerform.postDelayMs != 0) {
                                        haxe.Timer.delay(function callback() {
                                            character1.canChangeState = true;
                                            character1.actionState = CharacterActionState.READY;
                                            character1.actionToPerform = null;
                                        }, character1.actionToPerform.postDelayMs);
                                    } else {
                                        character1.canChangeState = true;
                                        character1.actionState = CharacterActionState.READY;
                                        character1.actionToPerform = null;
                                    }

                                    callbackParams.playActionAnim = true;

                                    sendCharacterActionCallbacks([callbackParams]);
                                }, character1.actionToPerform.performDelayMs);
                            }
                        }
                    }

                    character1.isRunning = false;
                }
            }

            sendCharacterActionCallbacks(characterActionCallbackParams);

            spawnMonsters();

            if (winCondition != WinCondition.INFINITE && allowServerLogic && aiManager.allMonstersKilled()) {
                setGameState(GameState.WIN);
            }

            recentEngineLoopTime = Date.now() - beginTime;
        }
    }

    public function customDestroy() {
        // clear callbacks
        aiManager.cleanMonsters();
        aiManager.setAllowSpawnMonsters(false);

        characterActionCallbacks = null;
        gameStateCallback = null;
        oneSecondCallback = null;
    }

    // ---------------------------------------------------
    // General
    // ---------------------------------------------------

    public function sendCharacterActionCallbacks(characterActionCallbackParams:Array<CharacterActionCallbackParams>) {
        if (characterActionCallbacks != null && characterActionCallbackParams.length > 0) {
            characterActionCallbacks(characterActionCallbackParams);
        }
    }

	public function addLineCollider(x1:Int, y1:Int, x2:Int, y2:Int) {
		lineColliders.push(new engine.base.geometry.Line(x1, y1, x2, y2));
	}

    public function setAllowSpawnMonsters(allowSpawnMonsters:Bool) {
        aiManager.setAllowSpawnMonsters(allowSpawnMonsters);
    }

    public function cleanAllMonsters() {
        for (entity in characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_BOY)) {
            characterEntityManager.delete(entity.getId());
        };
        for (entity in characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_GIRL)) {
            characterEntityManager.delete(entity.getId());
        };
        aiManager.cleanMonsters();
    }

    public function clearPlayerGainings(playerId:String) {
        playerZombiesKilled.remove(playerId);
        playerCoinsGained.remove(playerId);
    }

    public function createRandomConsumable(x:Int, y:Int) {
        var entityType = EntityType.COIN;
        final rnd = MathUtils.randomIntInRange(1, 40);
        if (rnd == 1) {
            entityType = EntityType.SALMON;
        } else if (rnd < 6) {
            entityType = EntityType.HEALTH_POTION;
        }
        createConsumable(x, y, entityType);
    }

    public function createConsumable(x:Int, y:Int, entityType:EntityType) {
        switch (entityType) {
            case EntityType.COIN:
                addToConsumableCreateQueue(SeidhEntityFactory.InitiateCoin(x, y, 1));
            case EntityType.HEALTH_POTION:
                addToConsumableCreateQueue(SeidhEntityFactory.InitiateHealthPotion(x, y, 20));
            case EntityType.SALMON:
                addToConsumableCreateQueue(SeidhEntityFactory.InitiateSalmon(x, y, 50));
            default:
        }
    }

    private function spawnMonsters() {
        final player = characterEntityManager.getEntityById(playerToEntityMap.get(localPlayerId));
        if (player != null) {
            final spawnMonster = aiManager.spawnMonster(player.getX(), player.getY());
            if (spawnMonster.spawn) {
                if (spawnMonster.entityType == EntityType.GLAMR) {
                    gameStageCallback(GameStage.KILL_BOSS);
                }
                addToCharacterCreateQueue(SeidhEntityFactory.InitiateCharacter(
                    {
                        x: spawnMonster.positionX,
                        y: spawnMonster.positionY,
                        entityType: spawnMonster.entityType,
                    }
                ));
            }
        }
    }

    private function createProjectileByCharacter(character:EngineCharacterEntity) {
        // final ownerRect = character.getBodyRectangle();
        // final projectileEntity = new EngineProjectileEntity(new ProjectileEntity({
        //     base: {
        //         x: Std.int(ownerRect.getCenter().x),
        //         y: Std.int(ownerRect.getCenter().y),
        //         entityType: EntityType.PROJECTILE_MAGIC_ARROW,
        //         entityShape: character.actionToPerform.projectileStruct.shape,
        //         ownerId: character.getOwnerId(),
        //         rotation: character.getRotation(),
        //     },
	    //     projectile: character.actionToPerform.projectileStruct
        // }));
        // return projectileEntity;
        return null;
    }

    private function getNearestPlayer(entity:EngineBaseEntity) {
        var nearestPlayer:EngineBaseEntity = null;
        var nearestPlayerDistance:Float = 0.0;

        for (targetEntity in characterEntityManager.entities) {
            if (targetEntity.isPlayer()) {
                final dist = entity.getBodyRectangle().getCenter().distance(targetEntity.getBodyRectangle().getCenter());
                if (nearestPlayer == null || dist < nearestPlayerDistance) {
                    nearestPlayer = targetEntity;
                    nearestPlayerDistance = dist;
                }
            }
        }

        return nearestPlayer;
    }

    private function oneTenthOfASecondTimer() {
        haxe.Timer.delay(function delay() {
            if (gameState == GameState.PLAYING) {
                if (winCondition == WinCondition.SURVIVE && secondsPassed >= secondsToSurvive) {
                    setGameState(GameState.WIN);
                } else {
                    if (msPassed++ == 10) {
                        msPassed = 0;
                        secondsPassed++;
                        if (oneSecondCallback != null) {
                            oneSecondCallback();
                        }
                        aiManager.secondPassed();
                    }
                    oneTenthOfASecondTimer();
                }
            }
        }, 100);
    }

    // ---------------------------------------------------
    // Getters
    // ---------------------------------------------------

    public function getLastDt() {
        return lastDt;
    }

    public function getGameState() {
        return gameState;
    }

    public function getLineColliders() {
        return lineColliders;
    }

    public function getPlayersSpawnPoints() {
        return playersSpawnPoints;
    }

    public function getMonstersSpawnPoints() {
        return aiManager.getMonstersSpawnPoints();
    }

    public function getMonstersMax() {
        return aiManager.getMonstersMax();
    }

    public function getMonstersLeft() {
        return aiManager.getMonstersLeft();
    }

    public function getPlayersCount() {
        return characterEntityManager.getEntitiesByEntityType(EntityType.RAGNAR_LOH).length;
    }

    public function getGameProgress(playerId:String) {
        final gainings = getPlayerGainings(playerId);
        return {
            monstersSpawned: aiManager.getMonstersSpawned(),
            zombiesKilled: gainings.zombiesKilled,
            coinsGained: gainings.coinsGained,
        }
    }

    public function getPlayerGainings(playerId:String) {
        return {
            zombiesKilled: playerZombiesKilled.exists(playerId) ? playerZombiesKilled.get(playerId) : 0,
            coinsGained: playerCoinsGained.exists(playerId) ? playerCoinsGained.get(playerId) : 0,
        };
    }

    public function getMonstersCount() {
        return 
            characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_BOY).length +
            characterEntityManager.getEntitiesByEntityType(EntityType.ZOMBIE_GIRL).length;
    }

    public function getWinCondition() {
        return winCondition;
    }

    public function getSecondsPassed() {
        return secondsPassed;
    }

    public function getSecondsToSurvive() {
        return secondsToSurvive;
    }

    // ---------------------------------------------------
    // Setters
    // ---------------------------------------------------

    public function setGameState(gameState:GameState) {
        this.gameState = gameState;
        if (gameStateCallback != null) {
            gameStateCallback(gameState);
        }
    }

    public function setMonstersMax(monstersMax:Int) {
        aiManager.setMonstersMax(monstersMax);
    }

    public function setWinCondition(winCondition:WinCondition) {
        this.winCondition = winCondition;
    }
}