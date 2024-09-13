package game.scene.base;

import engine.base.core.BaseEngine.DeleteConsumableEntityTask;
import hxd.Event.EventKind;
import h2d.Text;
import h3d.Engine;
import hxd.Key in K;

import game.entity.character.ClientCharacterEntity;
import game.entity.consumable.ClientConsumableEntity;
import game.fx.FxManager;
import game.js.NativeWindowJS;
import game.network.Networking;
import game.scene.GameUiScene.ButtonPressed;
import game.sound.SoundManager;
import game.terrain.TerrainManager;

import engine.base.BaseTypesAndClasses;
import engine.base.MathUtils;
import engine.base.core.BaseEngine.GameState;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.entity.impl.EngineConsumableEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.seidh.SeidhGameEngine;

import motion.Actuate;

typedef BasicSceneClickCallback = {
	clickX:Float,
	clickY:Float,
	eventKind:EventKind,
} 

// TODO this is not a basic scene, it a game actually
abstract class BasicScene extends h2d.Scene {

    public static var NetworkingInstance:Networking;

	public final seidhGameEngine:SeidhGameEngine;
	public final terrainManager:TerrainManager;
	public var debugGraphics:h2d.Graphics;

	private var gameUiScene:GameUiScene;
	private var fui:h2d.Flow;
	private var debugText:h2d.Text;

	private var playerEntity:ClientCharacterEntity;
	private var targetCursor:h2d.Bitmap;

	private final isMobileDevice:Bool;

	private var basicSceneCallback:BasicSceneClickCallback->Void;

	final clientCharacterEntities = new Map<String, ClientCharacterEntity>();
	final clientConsumableEntities = new Map<String, ClientConsumableEntity>();

	final charactersToDelete: Array<String> = [];
	
	var inputsSent = 0;

	public function new(seidhGameEngine:SeidhGameEngine, ?basicSceneCallback:BasicSceneClickCallback->Void) {
		super();

		this.basicSceneCallback = basicSceneCallback;

		// final mobile = NativeWindowJS.getMobile();
		// if (mobile != null) {
		// 	if (mobile != 'null' || mobile != 'undefined') {
		// 		isMobileDevice = true;
		// 	}
		// }

		isMobileDevice = true;

		if (seidhGameEngine != null) {
			terrainManager = new TerrainManager(this);

			camera.x = seidhGameEngine.getPlayersSpawnPoints()[0].x;
			camera.y = seidhGameEngine.getPlayersSpawnPoints()[0].y;

			this.seidhGameEngine = seidhGameEngine;

			this.seidhGameEngine.createCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
				final character = new ClientCharacterEntity(this, characterEntity);
				clientCharacterEntities.set(character.getId(), character);

				if (character.getOwnerId() == Player.instance.userId) {
					playerEntity = character;
					NativeWindowJS.trackGameStarted();
				}
			};

			this.seidhGameEngine.deleteCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
				if (!charactersToDelete.contains(characterEntity.getId())) {
					charactersToDelete.push(characterEntity.getId());
				}
			};

			this.seidhGameEngine.createProjectileCallback = function callback(projectileEntity:EngineProjectileEntity) {
				// final projectile = new ClientProjectileEntity(this);
				// projectile.initiateEngineEntity(projectileEntity);
				// clientProjectileEntities.set(projectileEntity.getId(), projectile);
			};

			this.seidhGameEngine.deleteProjectileCallback = function callback(projectileEntity:EngineProjectileEntity) {
				// final projectile = clientProjectileEntities.get(projectileEntity.getId());
				// if (projectile != null) {
				// 	clientProjectileEntities.remove(projectileEntity.getId());
				// 	removeChild(projectile);
				// }
			};

			// TODO need better abstraction for client entities
			this.seidhGameEngine.createConsumableCallback = function callback(consumableEntity:EngineConsumableEntity) {
				final consumable = new ClientConsumableEntity(this, consumableEntity);
				clientConsumableEntities.set(consumableEntity.getId(), consumable);
			};

			this.seidhGameEngine.deleteConsumableCallback = function callback(callbackBody:DeleteConsumableEntityTask) {
				final consumable = clientConsumableEntities.get(callbackBody.entityId);
				clientConsumableEntities.remove(callbackBody.entityId);

				if (consumable != null && callbackBody.takenByCharacterId == playerEntity.getId()) {
					if (consumable.getEntityType() == EntityType.COIN) {
						final point = new h2d.col.Point(camera.x + 530, camera.y - Main.ActualScreenHeight);
						Actuate.tween(consumable, 1, { 
							x: point.x,
							y: point.y,
							scaleX: 0.1,
							scaleY: 0.1,
							alpha: 0.2,
						}).onComplete(function callback() {
							removeChild(consumable);
						});
						gameUiScene.addGold();
					} else {
						final point = new h2d.col.Point(camera.x - 330, camera.y - Main.ActualScreenHeight);
						Actuate.tween(consumable, 1, { 
							x: point.x,
							y: point.y,
							scaleX: 0.1,
							scaleY: 0.1,
							alpha: 0.2,
						}).onComplete(function callback() {
							removeChild(consumable);
						});
						gameUiScene.addHealth();
					}
				} else {
					removeChild(consumable);
				}
			};

			this.seidhGameEngine.postLoopCallback = function callback() {
				for (mainEntity in seidhGameEngine.getCharacterEntitiesMap()) {
					if (clientCharacterEntities.exists(mainEntity.getId())) {
						final clientEntity = clientCharacterEntities.get(mainEntity.getId());
						clientEntity.setTragetServerPosition(mainEntity.getX(), mainEntity.getY());
					}
				}

				if (BasicScene.NetworkingInstance != null) {
					for (input in seidhGameEngine.validatedInputCommands) {
						if (input.userId == Player.instance.userId) {
							inputsSent++;
							BasicScene.NetworkingInstance.input(input);
						}
					}
				}
			};

			this.seidhGameEngine.characterActionCallbacks = function callback(params:Array<CharacterActionCallbackParams>) {
				for (value in params) {
					// Play action initiator animation
					final clientEntity = clientCharacterEntities.get(value.entityId);
					switch (value.actionType) {
						case CharacterActionType.ACTION_MAIN:
							clientEntity.actionMain();
							clientEntity.fxActionMain();		
						default: 
					}

					// Play hurt and dead animations
					for (value in value.hurtEntities) {
						final clientEntity = clientCharacterEntities.get(value);
						if (clientEntity != null) {
							clientEntity.fxHurt();
						}
					}
					for (value in value.deadEntities) {
						final clientEntity = clientCharacterEntities.get(value);
						if (clientEntity != null) {
							clientEntity.fxDeath();
						}
					}
				}
			};

			this.seidhGameEngine.gameStateCallback = function callback(gameState:GameState) {
				if (gameState == GameState.WIN) {
					NativeWindowJS.trackGameWin();
					gameUiScene.showWinDialog(this.seidhGameEngine.getPlayerGainings(Player.instance.userId).kills);
				} else {
					haxe.Timer.delay(function delay() {
						NativeWindowJS.trackGameLose();
						gameUiScene.showLoseDialog(0);
					}, 1500);
				}
			};

			this.seidhGameEngine.oneSecondCallback = function callback() {
				if (this.seidhGameEngine.getWinCondition() == WinCondition.SURVIVE) {
					gameUiScene.updateSurviveTimer(this.seidhGameEngine.getSecondsToSurvive(), this.seidhGameEngine.getSecondsPassed());
				}
			};
		}

		debugGraphics = new h2d.Graphics(this);
		addChild(debugGraphics);

		fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 5;
		fui.padding = 10;

		function onEvent(event:hxd.Event) {
			if (gameUiScene != null && this.seidhGameEngine.getGameState() == GameState.PLAYING) {
				if (event.kind == EMove) {
					gameUiScene.updateCursorPosition(event.relX, event.relY);
				} else if (event.kind == ERelease) {
					gameUiScene.release();
				}
			}
			if (event.kind == EPush && this.basicSceneCallback != null) {
				final clickPos = new h2d.col.Point(event.relX, event.relY);
				camera.screenToCamera(clickPos);

				this.basicSceneCallback({
					clickX: clickPos.x,
					clickY: clickPos.y,
					eventKind: event.kind
				});
			}
		}

		SoundManager.instance.initiate();
		FxManager.instance.initiate();
		FxManager.instance.setScene(this);

		hxd.Window.getInstance().addEventTarget(onEvent);

		onResize();
	}

	public abstract function start():Void;

	public abstract function customUpdate(dt:Float, fps:Float):Void;

	public function initNetwork() {
		if (BasicScene.NetworkingInstance == null) {
			BasicScene.NetworkingInstance = new Networking();
		}
	}

	public function destroy() {
		this.basicSceneCallback = null;
	}

	public function onResize() {
		final w = Main.ActualScreenWidth;
		final h = Main.ActualScreenHeight;

		if (seidhGameEngine != null) {
			if (isMobileDevice) {
				if (gameUiScene == null) {
					gameUiScene = new GameUiScene(
						isMobileDevice,
						function buttonPressedCallback(buttonPressed:ButtonPressed) {
							switch (buttonPressed) {
								case ButtonPressed.A:
									addInputCommand(CharacterActionType.ACTION_MAIN);
								default:
							}
						},
						function joystickMovedCallback(angle:Float) {
							addInputCommand(CharacterActionType.MOVE, angle);
						}
					);

					if (seidhGameEngine.getWinCondition() == WinCondition.SURVIVE) {
						gameUiScene.addSurviveTimer();
						gameUiScene.updateSurviveTimer(this.seidhGameEngine.getSecondsToSurvive(), this.seidhGameEngine.getSecondsPassed());
					}
				}

				gameUiScene.resize(Main.ScreenOrientation, w, h);
			}
		}

		if (isMobileDevice) {
			scaleMode = ScaleMode.Stretch(w, h);

			if (seidhGameEngine != null) {
				camera.setViewport(w / 2, h / 2, w, h);
				camera.setScale(0.5, 0.5);
			}
		} else {
			scaleMode = ScaleMode.LetterBox(w, h, true);
		}
	}

	public function update(dt:Float, fps:Float) {
		debugGraphics.clear();

		if (gameUiScene != null && playerEntity != null) {
			gameUiScene.update(playerEntity.getCurrentHealth(), playerEntity.getMaxHealth());
		}

		// updateDesktopInput();
		customUpdate(dt, fps);

		if (playerEntity != null) {
			camera.x = playerEntity.x;
			camera.y = playerEntity.y;
		}
	}

	public override function render(e:Engine) {
		for (character in clientCharacterEntities) {
			if (GameConfig.instance.DebugDraw) {
				character.debugDraw(debugGraphics);
			}
		}
		super.render(e);
		if (gameUiScene != null) {
			gameUiScene.render(e);
		}
	}

	public function getInputScene() {
		return gameUiScene != null ? gameUiScene : this;
	}

	private function updateDesktopInput() {
		if (!isMobileDevice) {
			// Movement
			final left = K.isDown(K.LEFT);
			final right = K.isDown(K.RIGHT);
			final up = K.isDown(K.UP);
			final down = K.isDown(K.DOWN);

			if (left || right || up || down) {
				final playerActionInputType = CharacterActionType.MOVE;
				var angle = 0.0;
				if (left)
					angle = MathUtils.degreeToRads(180);
				if (down)
					angle = MathUtils.degreeToRads(90);
				if (up)
					angle = MathUtils.degreeToRads(260);
				addInputCommand(playerActionInputType, angle);
			}

			// Action
			final space = K.isDown(K.SPACE);
			final alt = K.isDown(K.ALT);
			var playerActionInputType:CharacterActionType = null;

			if (space) {
				playerActionInputType = CharacterActionType.ACTION_MAIN;
			} else if (alt) {
				playerActionInputType = CharacterActionType.ACTION_1;
			}

			if (playerActionInputType != null) {
				addInputCommand(playerActionInputType);
			}
		}
	}

	private function addInputCommand(characterActionType:CharacterActionType, moveAngle:Float = 0) {
		final userId = Player.instance.userId;
		final userEntityId = Player.instance.userEntityId;

		final allowInput = characterActionType == CharacterActionType.MOVE ? 
			seidhGameEngine.checkLocalMovementInputAllowance(userEntityId) :
			seidhGameEngine.checkLocalActionInputAllowance(userEntityId, characterActionType);
		
		if (allowInput) {
			seidhGameEngine.addInputCommandClient(new PlayerInputCommand(characterActionType, moveAngle, userId, Player.instance.incrementAndGetInputIndex()));
		}
	}

	// ----------------------------------
	// Entities
	// ----------------------------------

	public function createCharacterEntityFromMinimalStruct(id:String, ownerId:String, x:Int, y:Int, entityType:EntityType) {
		seidhGameEngine.createCharacterEntityFromMinimalStruct({
			id: id, 
			ownerId: ownerId, 
			x: x, 
			y: y,
			entityType: entityType
		});
	}

	function deleteCharacterByDeathAnimationEnd(characterId:String) {
		// if (charactersToDelete.contains(characterId)) {
		// 	charactersToDelete.remove(characterId);

		// 	final character = clientCharacterEntities.get(characterId);
		// 	if (character != null) {
		// 		clientCharacterEntities.remove(characterId);
		// 		if (!character.isPlayer()) {
		// 			FxManager.instance.zombieBlood(character.x, character.y, character.getSide(), character.getEntityType());
		// 			removeChild(character);
		// 		}
		// 	}
		// }
	}

	// ----------------------------------
	// GUI
	// ----------------------------------

	public function addButton(label: String, onClick: h2d.Flow -> Void) {
		final f = new h2d.Flow(fui);
		f.padding = 25;
		f.backgroundTile = h2d.Tile.fromColor(0x404040);
		var tf = new h2d.Text(hxd.res.DefaultFont.get(), f);
		tf.text = label;
		f.enableInteractive = true;
		f.interactive.cursor = Button;
		f.interactive.onClick = function(_) onClick(f);
		f.interactive.onOver = function(_) f.backgroundTile = h2d.Tile.fromColor(0x606060);
		f.interactive.onOut = function(_) f.backgroundTile = h2d.Tile.fromColor(0x404040);
		return f;
	}

	public function addText(label:String) {
		final text = new h2d.Text(hxd.res.DefaultFont.get(), fui);
		text.textColor = GameConfig.RedColor;
		text.text = label;
		return text;
	}

	function addSlider( label : String, get : Void -> Float, set : Float -> Void, min : Float = 0., max : Float = 1. ) {
		var f = new h2d.Flow(fui);

		f.horizontalSpacing = 5;

		var tf = new h2d.Text(hxd.res.DefaultFont.get(), f);
		tf.text = label;
		tf.maxWidth = 70;
		tf.textAlign = Right;

		var sli = new h2d.Slider(100, 10, f);
		sli.minValue = min;
		sli.maxValue = max;
		sli.value = get();

		var tf = new h2d.TextInput(hxd.res.DefaultFont.get(), f);
		tf.text = "" + hxd.Math.fmt(sli.value);
		sli.onChange = function() {
			set(sli.value);
			tf.text = "" + hxd.Math.fmt(sli.value);
			f.needReflow = true;
		};
		tf.onChange = function() {
			var v = Std.parseFloat(tf.text);
			if( Math.isNaN(v) ) return;
			sli.value = v;
			set(v);
		};
		return sli;
	}

}