package game.scene.impl.game;

import engine.seidh.types.TypesSeidhGame;
import engine.seidh.types.TypesSeidhGame.GameStage;
import h3d.Engine;
import hxd.Key;

import motion.Actuate;

import engine.base.MathUtils;
import engine.base.core.BaseEngine.GameState;
import engine.base.types.TypesBaseEntity.CharacterActionCallbackParams;
import engine.base.core.BaseEngine.DeleteConsumableEntityTask;
import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.geometry.Rectangle;
import engine.base.types.TypesBaseEntity.CharacterActionEffect;
import engine.base.types.TypesBaseEntity.CharacterEntityFullStruct;
import engine.base.types.TypesBaseMultiplayer.PlayerInputCommand;
import engine.base.types.TypesBaseEntity.CharacterActionType;
import engine.base.types.TypesBaseEntity.EntityType;
import engine.base.types.TypesBaseEngine;
import engine.seidh.SeidhGameEngine;
import engine.seidh.entity.CharacterEntityConfig;
import engine.seidh.entity.factory.SeidhEntityFactory;
import engine.seidh.types.TypesSeidhGame.WinCondition;

import game.analytics.Analytics;
import game.js.NativeWindowJS;
import game.fx.FxManager;
import game.entity.character.ClientCharacterEntity;
import game.entity.consumable.ClientConsumableEntity;
import game.event.EventManager;
import game.event.EventManager.EventListener;
import game.terrain.TerrainManager;
import game.network.Networking;
import game.scene.base.BasicScene;
import game.scene.impl.game.GameUiScene;
import game.sound.SoundManager;
import game.utils.Utils;

class GameScene extends BasicScene implements EventListener {

	// NEED ?
	public static final LAYER_GRASS = 0;
	public static final LAYER_GROUND = 1;
	public static final LAYER_TREE = 2;
	public static final LAYER_CHARACTERS_AND_BOOSTS = 3;
	public static final LAYER_EFFECTS = 4;

	private var seidhGameEngine:SeidhGameEngine;
	private var terrainManager:TerrainManager;
	private var fxManager:FxManager;

	private var gameUiScene:GameUiScene;
	private var playerEntity:ClientCharacterEntity;
	private var bossEntity:ClientCharacterEntity;
	private var progressTimer:haxe.Timer;
	
	private var clientCharacterEntities = new Map<String, ClientCharacterEntity>();
	private var clientConsumableEntities = new Map<String, ClientConsumableEntity>();
	private var charactersToDelete: Array<String> = [];
	private var monstersSpawned = 0;
	private var inputsSent = 0;

    public function new(engineMode:EngineMode, winCondition:WinCondition) {
		super();

		// -------------------------------------------
		// Init
		// -------------------------------------------

		terrainManager = new TerrainManager(this);
		fxManager = new FxManager(this);

		seidhGameEngine = new SeidhGameEngine(engineMode, winCondition);
		seidhGameEngine.gameId = Player.instance.currentGameId;

		camera.x = seidhGameEngine.getPlayersSpawnPoints()[0].x;
		camera.y = seidhGameEngine.getPlayersSpawnPoints()[0].y;

		// -------------------------------------------
		// Engine callbacks
		// -------------------------------------------

		seidhGameEngine.createCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
			final character = new ClientCharacterEntity(this, characterEntity);
			clientCharacterEntities.set(character.getId(), character);

			if (character.getOwnerId() == Player.instance.userInfo.userId) {
				playerEntity = character;
				Analytics.instance.trackGameStarted(this.seidhGameEngine.gameId);
			}

			if (character.getEntityType() == EntityType.GLAMR) {
				bossEntity = character;
			}
		};

		seidhGameEngine.deleteCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
			if (!charactersToDelete.contains(characterEntity.getId())) {
				charactersToDelete.push(characterEntity.getId());
			}
		};

		seidhGameEngine.createProjectileCallback = function callback(projectileEntity:EngineProjectileEntity) {
			// final projectile = new ClientProjectileEntity(this);
			// projectile.initiateEngineEntity(projectileEntity);
			// clientProjectileEntities.set(projectileEntity.getId(), projectile);
		};

		seidhGameEngine.deleteProjectileCallback = function callback(projectileEntity:EngineProjectileEntity) {
			// final projectile = clientProjectileEntities.get(projectileEntity.getId());
			// if (projectile != null) {
			// 	clientProjectileEntities.remove(projectileEntity.getId());
			// 	removeChild(projectile);
			// }
		};

		seidhGameEngine.createConsumableCallback = function callback(consumableEntity:EngineConsumableEntity) {
			final consumable = new ClientConsumableEntity(this, consumableEntity);
			clientConsumableEntities.set(consumableEntity.getId(), consumable);
		};

		seidhGameEngine.deleteConsumableCallback = function callback(callbackBody:DeleteConsumableEntityTask) {
			final character = clientCharacterEntities.get(callbackBody.takenByCharacterId);
			final consumable = clientConsumableEntities.get(callbackBody.entityId);
			clientConsumableEntities.remove(callbackBody.entityId);

			if (character != null && consumable != null) {
				consumable.clearTween();

				final point = new h2d.col.Point(character.x, character.y);
				Actuate.tween(consumable, 0.6, {
					x: point.x,
					y: point.y,
					scaleX: 0.3,
					scaleY: 0.3,
					alpha: 0,
				}).onComplete(function callback() {
					removeChild(consumable);
				});

				if (callbackBody.takenByCharacterId == playerEntity.getId()) {
					if (consumable.getEntityType() == EntityType.COIN) {
						final gainings = seidhGameEngine.getPlayerGainings(playerEntity.getOwnerId());
						gameUiScene.addCoins(gainings.coinsGained);
						fxManager.coinText(character.x, character.y, 1.5, character.getSide(), consumable.getConsumableAmount());
					} else {
						gameUiScene.addHealth();
						fxManager.healText(character.x, character.y, 2.0, character.getSide(), consumable.getConsumableAmount());
					}
				}
			}
		};

		seidhGameEngine.postLoopCallback = function callback() {
			for (mainEntity in seidhGameEngine.getCharacterEntitiesMap()) {
				if (clientCharacterEntities.exists(mainEntity.getId())) {
					final clientEntity = clientCharacterEntities.get(mainEntity.getId());
					clientEntity.setTragetServerPosition(mainEntity.getX(), mainEntity.getY());
				}
			}

			if (Main.NetworkingInstance != null) {
				for (input in seidhGameEngine.validatedInputCommands) {
					if (input.userId == Player.instance.userInfo.userId) {
						inputsSent++;
						Main.NetworkingInstance.input(input);
					}
				}
			}
		};

		seidhGameEngine.characterActionCallbacks = function callback(params:Array<CharacterActionCallbackParams>) {
			for (param in params) {
				final clientEntity = clientCharacterEntities.get(param.entityId);

				if (clientEntity != null) {
					if (param.playActionAnim) {
						clientEntity.performAction(param.actionType, false);
					}

					// Play effects
					if (param.playEffectAnim) {
						if (param.actionEffect == CharacterActionEffect.ATTACK) {
							switch (clientEntity.getEntityType()) {
								case RAGNAR_LOH:
									final fxPosX = clientEntity.getSide() == RIGHT ? clientEntity.x + 50 : clientEntity.x - 50;
									fxManager.ragnarAttack(fxPosX, clientEntity.y, clientEntity.getSide());
									SoundManager.instance.playVikingHit();
								case ZOMBIE_BOY:
									SoundManager.instance.playZombieHit();
								case ZOMBIE_GIRL:
									SoundManager.instance.playZombieHit();
								case GLAMR:
									final fxPosX = clientEntity.getSide() == RIGHT ? clientEntity.x + 170 : clientEntity.x - 170;
									final fxPosY = clientEntity.y + 30;
									fxManager.glamrEyeAttack(fxPosX, fxPosY, clientEntity.getSide());
								default:
							}
						}
					}

					if (param.hurtEntities != null && param.deadEntities != null) {
						for (entity in param.hurtEntities) {
							final clientEntity = clientCharacterEntities.get(entity);
							if (clientEntity != null) {
								fxManager.damageText(clientEntity.x, clientEntity.y, 2.0, clientEntity.getSide(), param.damage);
							}
						}
						for (value in param.deadEntities) {
							final clientEntity = clientCharacterEntities.get(value);
							if (clientEntity != null) {
								clientEntity.fxDeath();
								fxManager.damageText(clientEntity.x, clientEntity.y, 2.0, clientEntity.getSide(), param.damage);
							}
						}
					}
				}
			}
		};

		seidhGameEngine.gameStateCallback = function callback(gameState:GameState) {
			var reason = 'Win';
			if (gameState == GameState.WIN) {
				// Analytics.instance.trackGameWin(seidhGameEngine.gameId);
				gameUiScene.showWinDialog(seidhGameEngine.getPlayerGainings(Player.instance.userInfo.userId).zombiesKilled);
			} else if (gameState == GameState.LOSE) {
				reason = 'Lose';
				haxe.Timer.delay(function delay() {
					// Analytics.instance.trackGameLose(seidhGameEngine.gameId);
					gameUiScene.showLoseDialog(0);
				}, 1500);
			}

			finishGame(reason);
		};

		seidhGameEngine.gameStageCallback = function callback(gameStage:GameStage) {
			if (gameStage == GameStage.KILL_BOSS) {
				gameUiScene.showBossBar();
			}
		};

		seidhGameEngine.oneSecondCallback = function callback() {
			if (this.seidhGameEngine.getWinCondition() == WinCondition.SURVIVE) {
				gameUiScene.updateSurviveTimerObjective(this.seidhGameEngine.getSecondsToSurvive(), this.seidhGameEngine.getSecondsPassed());
			}
		};

		// -------------------------------------------
		// Event subscription
		// -------------------------------------------

		if (engineMode == EngineMode.CLIENT_MULTIPLAYER) {
			EventManager.instance.subscribe(EventManager.EVENT_GAME_INIT, this);
			EventManager.instance.subscribe(EventManager.EVENT_LOOP_STATE, this);
			EventManager.instance.subscribe(EventManager.EVENT_GAME_STATE, this);
			EventManager.instance.subscribe(EventManager.EVENT_CREATE_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_DELETE_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_CREATE_CONSUMABLE, this);
			EventManager.instance.subscribe(EventManager.EVENT_DELETE_CONSUMABLE, this);
			EventManager.instance.subscribe(EventManager.EVENT_CHARACTER_ACTIONS, this);

            Main.NetworkingInstance.findAndJoinGame();
		} else if (engineMode == EngineMode.CLIENT_SINGLEPLAYER) {
			EventManager.instance.subscribe(EventManager.EVENT_SPAWN_CHARACTER, this);
			EventManager.instance.subscribe(EventManager.EVENT_SPAWN_CONSUMABLE, this);

			createCharacterEntityFromFullStruct({
				base: {
					x: Std.int(seidhGameEngine.getPlayersSpawnPoints()[0].x),
					y: Std.int(seidhGameEngine.getPlayersSpawnPoints()[0].y),
					entityType: EntityType.RAGNAR_LOH,
					entityShape: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.entityShape,
					id: Player.instance.currentCharacter.id,
					ownerId: Player.instance.userInfo.userId,
				},
				movement: {
					canRun: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.movement.canRun,
					inputDelay: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.movement.inputDelay,
					runSpeed: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.movement.runSpeed,
					speedFactor: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.movement.speedFactor,
				},
				health: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.health,
				actionMain: {
					actionType: CharacterActionType.ACTION_MAIN,
					actionEffect: CharacterActionEffect.ATTACK,
					damage: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.damage,
					inputDelay: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.inputDelay,
					performDelayMs: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.performDelayMs,
					postDelayMs: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.postDelayMs,
					meleeStruct: {
						aoe: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.meleeStruct.aoe,
						shape: {
							width: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.meleeStruct.shape.width,
							height: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.meleeStruct.shape.height,
							rectOffsetX:CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.meleeStruct.shape.rectOffsetX,
							rectOffsetY: CharacterEntityConfig.CHARACTERS_CONFIG.ragnarLoh.actionMain.meleeStruct.shape.rectOffsetY,
							radius: 0,
						},
					},
				},
			});

			seidhGameEngine.setAllowSpawnMonsters(true);
			seidhGameEngine.setLocalPlayerId(Player.instance.userInfo.userId);

			gameProgress();
		}

		EventManager.instance.subscribe(EventManager.EVENT_CHARACTER_DEATH_ANIM_END, this);
		EventManager.instance.subscribe(EventManager.EVENT_PLAYER_MAIN_ACTION, this);
		EventManager.instance.subscribe(EventManager.EVENT_PLAYER_MOVE, this);

		// -------------------------------------------
		// Visual borders
		// -------------------------------------------

		// Top
		final topBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, Std.int(SeidhGameEngine.GameWorldSize / 2), 1));
		topBorder.setPosition(0, -topBorder.tile.height);
		topBorder.zOrder = 99;
		add(topBorder);

		// Bottom
		final bottomBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, Std.int(SeidhGameEngine.GameWorldSize / 2), 1));
		bottomBorder.setPosition(0, SeidhGameEngine.GameWorldSize);
		bottomBorder.zOrder = 99;
		add(bottomBorder);

		// Left
		final leftBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, SeidhGameEngine.GameWorldSize * 2, 1));
		leftBorder.setPosition(-leftBorder.tile.width, -SeidhGameEngine.GameWorldSize / 2);
		leftBorder.zOrder = 99;
		add(leftBorder);

		// Right
		final rightBorder = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, SeidhGameEngine.GameWorldSize, SeidhGameEngine.GameWorldSize * 2, 1));
		rightBorder.setPosition(SeidhGameEngine.GameWorldSize, -SeidhGameEngine.GameWorldSize / 2);
		rightBorder.zOrder = 99;
		add(rightBorder);
    }

    // --------------------------------------
	// Abstraction
	// --------------------------------------

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_GAME_INIT:
				processGameInitEvent(message);
			case EventManager.EVENT_GAME_STATE:
				processGameStateEvent(message);
			case EventManager.EVENT_LOOP_STATE:
				processLoopStateEvent(message);
			case EventManager.EVENT_CREATE_CHARACTER:
				processCreateCharacterEntityEvent(message);
			case EventManager.EVENT_DELETE_CHARACTER:
				processDeleteCharacterEntityEvent(message);
			case EventManager.EVENT_CREATE_CONSUMABLE:
				processCreateConsumableEntityEvent(message);
			case EventManager.EVENT_DELETE_CONSUMABLE:
				processDeleteConsumableEntityEvent(message);
			case EventManager.EVENT_CHARACTER_ACTIONS:
				processCharacterActions(message);
			case EventManager.EVENT_CHARACTER_DEATH_ANIM_END:
				processCharacterDeadAnimationEnd(message);
			case EventManager.EVENT_PLAYER_MAIN_ACTION:
				processPlayerMainAction();
			case EventManager.EVENT_PLAYER_MOVE:
				processPlayerMove(message);
			case EventManager.EVENT_SPAWN_CHARACTER:
				processSpawnCharacter(message);
			case EventManager.EVENT_SPAWN_CONSUMABLE:
				processSpawnConsumable(message);
		}
	}

	public function absOnEvent(event:hxd.Event) {
		if (gameUiScene != null && this.seidhGameEngine.getGameState() == GameState.PLAYING) {
			if (event.kind == EMove) {
				gameUiScene.updateCursorPosition(event.relX, event.relY);
			} else if (event.kind == ERelease) {
				gameUiScene.release();
			}
		}
	}

	public function absOnResize(w:Int, h:Int) {
		camera.setViewport(w / 2, h / 2, w, h);
		camera.setScale(0.5, 0.5);

		gameUiInit();

		if (gameUiScene != null) {
			gameUiScene.resize(DeviceInfo.ScreenOrientation, w, h);
		}
	}

	public function absStart() {
		SoundManager.instance.playGameplayTheme();

		if (seidhGameEngine.getWinCondition() == WinCondition.SURVIVE) {
			gameUiScene.showObjectiveText();
			gameUiScene.updateSurviveTimerObjective(this.seidhGameEngine.getSecondsToSurvive(), this.seidhGameEngine.getSecondsPassed());
		}
	}

	public function absRender(e:Engine) {
		for (character in clientCharacterEntities) {
			if (GameClientConfig.instance.DebugDraw) {
				character.debugDraw(debugGraphics);
			}
		}
	}

	public function absDestroy() {
		EventManager.instance.unsubscribe(EventManager.EVENT_GAME_INIT, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_LOOP_STATE, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_GAME_STATE, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_CREATE_CHARACTER, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_DELETE_CHARACTER, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_CREATE_CONSUMABLE, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_DELETE_CONSUMABLE, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_CHARACTER_ACTIONS, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_CHARACTER_DEATH_ANIM_END, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_PLAYER_MAIN_ACTION, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_PLAYER_MOVE, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_SPAWN_CHARACTER, this);
		EventManager.instance.unsubscribe(EventManager.EVENT_SPAWN_CONSUMABLE, this);

		// terrainManager = null;
		// debugGraphics = null;
		// gameUiScene = null;
		// basicSceneCallback = null;
		// clientCharacterEntities = null;
		// clientConsumableEntities = null;

		// fxManager.dispose();
		// seidhGameEngine.destroy();

		finishGame('Closed');
		// seidhGameEngine = null;
	}

	public function absUpdate(dt:Float, fps:Float) {
		final characterToEnvIntersections = new Array<Dynamic>();

		if (playerEntity != null && GameClientConfig.instance.adjustRagnar) {
			playerEntity.ajdustMovement(
				GameClientConfig.instance.CharacterMovementSpeed,
				GameClientConfig.instance.CharacterMovementInputDelay,
			);
			playerEntity.adjustActionMain(
				GameClientConfig.instance.CharacterActionMainWidth,
				GameClientConfig.instance.CharacterActionMainHeight,
				GameClientConfig.instance.CharacterActionMainOffsetX,
				GameClientConfig.instance.CharacterActionMainOffsetY,
				GameClientConfig.instance.CharacterActionMainInputDelay,
				GameClientConfig.instance.CharacterActionMainDamage,
			);
		}

		if (gameUiScene != null) {
			gameUiScene.updateUi();

			if (playerEntity != null) {
				gameUiScene.updatePlayer(playerEntity.getCurrentHealth(), playerEntity.getMaxHealth());

				camera.x = playerEntity.x;
				camera.y = playerEntity.y;
			}
			if (bossEntity != null) {
				gameUiScene.updateBossHealth(bossEntity.getCurrentHealth(), bossEntity.getMaxHealth());
			} else {
				if (seidhGameEngine.getWinCondition() == WinCondition.KILL_MONSTERS || 
					seidhGameEngine.getWinCondition() == WinCondition.KILL_MONSTERS_AND_BOSS) 
				{
					final monstersLeft = seidhGameEngine.getMonstersLeft();
					if (monstersLeft == 0 && seidhGameEngine.getWinCondition() == WinCondition.KILL_MONSTERS_AND_BOSS) {
						gameUiScene.killTheBossObjective();
					} else {
						gameUiScene.updateMonstersLeftObjective(monstersLeft);
					}
				}
			}
		}

		for (character in clientCharacterEntities) {
			character.update(dt, fps);

			characterToEnvIntersections.push(character);

			// final characterBottom = character.getBottomRect().getCenter();
			final characterRect = character.getRect();

			for (terrain in terrainManager.terrainArray) {
				// final treeBottom = tree.getBottomRect().getCenter();
				final terrainRect = terrain.getRect();
	
				if (terrainRect.getCenter().distance(characterRect.getCenter()) < 300) {
					if (terrainRect.intersectsWithRect(characterRect)) {
						characterToEnvIntersections.push(terrain);
					}
		
					if (characterToEnvIntersections.length > 1) {
						characterToEnvIntersections.sort((a, b) -> {
							final aBottom = a.getBottomRect().getCenter();
							final bBottom = b.getBottomRect().getCenter();
							return aBottom.y - bBottom.y;
						});
		
						for (index => env in characterToEnvIntersections) {
							env.zOrder = index;
						}
					}
				}
			}
		}

		if (characterToEnvIntersections.length > 0) {
			sortObjectsByZOrder();
		}

		for (consumable in clientConsumableEntities) {
			consumable.update(dt, fps);
		}

		if (GameClientConfig.instance.DebugDraw) {
			for (line in seidhGameEngine.getLineColliders()) {
				Utils.DrawLine(
					debugGraphics,
					line.x1,
					line.y1,
					line.x2,
					line.y2, 
					GameClientConfig.RedColor
				);
			}

			for (character in clientCharacterEntities) {
			}

			for (consumable in clientConsumableEntities) {
				consumable.debugDraw(debugGraphics);
			}

			for (spawnPoint in seidhGameEngine.getMonstersSpawnPoints()) {
				Utils.DrawRectFilled(
					debugGraphics,
					new Rectangle(spawnPoint.x, spawnPoint.y, 50, 50, 0),
					GameClientConfig.RedColor
				);
			}
		}

		if (!DeviceInfo.IsMobile) {
			if (Key.isDown(Key.W) || Key.isDown(Key.UP)) {
				addInputCommand(CharacterActionType.MOVE, MathUtils.degreeToRads(-90));
			}
			if (Key.isDown(Key.A) || Key.isDown(Key.LEFT)) {
				addInputCommand(CharacterActionType.MOVE, MathUtils.degreeToRads(180));
			}
			if (Key.isDown(Key.S) || Key.isDown(Key.DOWN)) {
				addInputCommand(CharacterActionType.MOVE, MathUtils.degreeToRads(90));
			}
			if (Key.isDown(Key.D) || Key.isDown(Key.RIGHT)) {
				addInputCommand(CharacterActionType.MOVE, MathUtils.degreeToRads(0));
			}
			if (Key.isDown(Key.CTRL)) {
				addInputCommand(CharacterActionType.ACTION_MAIN);
			}
		}
	}

	// ---------------------------------------
	// General
	// ---------------------------------------

	public function createCharacterEntityFromFullStruct(struct:CharacterEntityFullStruct) {
		seidhGameEngine.createCharacterEntityFromFullStruct(struct);
	}

	private function finishGame(reason:String) {
		if (progressTimer != null) {
			progressTimer.stop();
			progressTimer = null;
		}

		if (seidhGameEngine != null) {
			final progress = seidhGameEngine.getGameProgress(Player.instance.userInfo.userId);
			NativeWindowJS.networkGameFinish(
				function networkGameFinishCallback(data:Dynamic) {
					Player.instance.currentGameId = null;
				},
				Player.instance.currentGameId,
				reason,
				progress.monstersSpawned,
				progress.zombiesKilled,
				progress.coinsGained,
			);
		}
	}

	private function gameProgress() {
		if (Player.instance.currentGameId != null) {
			progressTimer = haxe.Timer.delay(function delay() {
				final progress = seidhGameEngine.getGameProgress(Player.instance.userInfo.userId);

				NativeWindowJS.networkGameProgress(
					function gameProgressCallback(data:Dynamic) {
						// if error > stop sending the data ?
					},
					Player.instance.currentGameId,
					progress.monstersSpawned,
					progress.zombiesKilled,
					progress.coinsGained,
				);

				gameProgress();
			}, 5000);
		}
	}

	private function addInputCommand(characterActionType:CharacterActionType, moveAngle:Float = 0) {
		final userId = Player.instance.userInfo.userId;
		final userEntityId = Player.instance.currentCharacter.id;

		final allowInput = characterActionType == CharacterActionType.MOVE ? 
			this.seidhGameEngine.checkLocalMovementInputAllowance(userEntityId) :
			this.seidhGameEngine.checkLocalActionInputAllowance(userEntityId, characterActionType);
		
		if (allowInput) {
			seidhGameEngine.addInputCommandClient(new PlayerInputCommand(characterActionType, moveAngle, userId, Player.instance.incrementAndGetInputIndex()));
		}
	}

	private function deleteCharacterByDeathAnimationEnd(characterId:String) {
		if (charactersToDelete.contains(characterId)) {
			charactersToDelete.remove(characterId);

			final character = clientCharacterEntities.get(characterId);
			if (character != null) {
				clientCharacterEntities.remove(characterId);
				if (!character.isPlayer()) {
					fxManager.remains(character.x, character.y, character.getEntityType(), character.getSide());
					removeChild(character);
				}
			}
		}
	}

    // --------------------------------------
	// Game UI
	// --------------------------------------

	private function gameUiInit() {
		if (gameUiScene == null) {
			gameUiScene = new GameUiScene();
			gameUiScene.showObjectiveText();
			setUiScene(gameUiScene);
		}
	}

	// ---------------------------------------
	// Server -> Client socket events
	// ---------------------------------------

	private function processGameInitEvent(payload:GameInitPayload) {
		for (characterStruct in payload.charactersFullStruct ) {
			seidhGameEngine.createCharacterEntityFromFullStruct(characterStruct);
		}
		seidhGameEngine.setLocalPlayerId(Player.instance.userInfo.userId);
	}

	private function processLoopStateEvent(payload:LoopStatePayload) {
		seidhGameEngine.updateCharacterEntitiesByServer(payload.charactersMinStruct);
	}

	private function processGameStateEvent(payload:GameStatePayload) {
		seidhGameEngine.setGameState(payload.gameState);
	}

	private function processCreateCharacterEntityEvent(payload:CreateCharacterPayload) {
		seidhGameEngine.createCharacterEntityFromFullStruct(payload.characterEntityFullStruct);
	}

	private function processDeleteCharacterEntityEvent(payload:DeleteCharacterPayload) {
		seidhGameEngine.addToCharacterDeleteQueue(payload.characterId);
	}

	private function processCreateConsumableEntityEvent(payload:CreateConsumablePayload) {
		final consumableStruct = payload.consumableEntityStruct.baseEntityStruct;
		switch (payload.consumableEntityStruct.baseEntityStruct.entityType) {
			case COIN:
				seidhGameEngine.addToConsumableCreateQueue(SeidhEntityFactory.InitiateCoin(consumableStruct.id, consumableStruct.x, consumableStruct.y, payload.consumableEntityStruct.amount));
			case HEALTH_POTION:
				seidhGameEngine.addToConsumableCreateQueue(SeidhEntityFactory.InitiateHealthPotion(consumableStruct.id, consumableStruct.x, consumableStruct.y, payload.consumableEntityStruct.amount));
			case SALMON:
				seidhGameEngine.addToConsumableCreateQueue(SeidhEntityFactory.InitiateSalmon(consumableStruct.id, consumableStruct.x, consumableStruct.y, payload.consumableEntityStruct.amount));
			default:
		}
	}

	private function processDeleteConsumableEntityEvent(payload:DeleteConsumablePayload) {
		seidhGameEngine.addToConsumableDeleteQueue(payload.entityId, payload.takenByCharacterId);
	}

	private function processCharacterActions(payload:ActionsPayload) {
		for (action in payload.actions) {
			if (action.entityId != Player.instance.currentCharacter.id) {
				seidhGameEngine.setCharacterNextActionToPerform(action.entityId, action.actionType);
			}
		}
	}

	// ---------------------------------------
	// Internal events
	// ---------------------------------------

	private function processCharacterDeadAnimationEnd(characterId:String) {
		deleteCharacterByDeathAnimationEnd(characterId);
	}

	private function processPlayerMainAction() {
		addInputCommand(CharacterActionType.ACTION_MAIN);
	}

	private function processPlayerMove(angle:Float) {
		addInputCommand(CharacterActionType.MOVE, angle);
	}

	private function processSpawnCharacter(payload:Dynamic) {
		var characterConfig:CharacterDefaultConfig = null;

		switch (payload.entityType) {
			case EntityType.ZOMBIE_BOY:
				characterConfig = CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy;
			case EntityType.ZOMBIE_GIRL:
				characterConfig = CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl;
			case EntityType.GLAMR:
				characterConfig = CharacterEntityConfig.CHARACTERS_CONFIG.glamr;
		}

		createCharacterEntityFromFullStruct({
			base: {
				x: 2800,
				y: 2500,
				entityType: payload.entityType,
				entityShape: characterConfig.entityShape,
				id: 'bot_' + monstersSpawned++,
				ownerId: 'bot_' + monstersSpawned,
			},
			movement: {
				canRun: characterConfig.movement.canRun,
				inputDelay: characterConfig.movement.inputDelay,
				runSpeed: characterConfig.movement.runSpeed,
				speedFactor: characterConfig.movement.speedFactor,
			},
			health: characterConfig.health,
			actionMain: {
				actionType: CharacterActionType.ACTION_MAIN,
				actionEffect: CharacterActionEffect.ATTACK,
				damage: characterConfig.actionMain.damage,
				inputDelay: characterConfig.actionMain.inputDelay,
				performDelayMs: characterConfig.actionMain.performDelayMs,
				postDelayMs: characterConfig.actionMain.postDelayMs,
				meleeStruct: {
					aoe: characterConfig.actionMain.meleeStruct.aoe,
					shape: {
						width: characterConfig.actionMain.meleeStruct.shape.width,
						height: characterConfig.actionMain.meleeStruct.shape.height,
						rectOffsetX: characterConfig.actionMain.meleeStruct.shape.rectOffsetX,
						rectOffsetY: characterConfig.actionMain.meleeStruct.shape.rectOffsetY,
						radius: 0,
					},
				},
			},
			action1: characterConfig.action1,
			action2: characterConfig.action2,
		});
	}

	private function processSpawnConsumable(payload:Dynamic) {
		seidhGameEngine.createConsumable(3000, 2500, EntityType.HEALTH_POTION);
	}

}