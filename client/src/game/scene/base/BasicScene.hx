package game.scene.base;

import game.sound.SoundManager;
import format.pex.Data.EmitterType;
import game.ui.dialog.Dialog;
import hxd.Event.EventKind;
import h2d.Text;
import h3d.Engine;
import hxd.Key in K;

import game.entity.character.ClientCharacterEntity;
import game.event.EventManager;
// import game.entity.projectile.ClientProjectileEntity;
import game.js.NativeWindowJS;
import game.network.Networking;
import game.scene.GameUiScene.ButtonPressed;
import game.terrain.TerrainManager;

import engine.base.BaseTypesAndClasses;
import engine.base.MathUtils;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.seidh.SeidhGameEngine;

typedef BasicSceneClickCallback = {
	clickX:Float,
	clickY:Float,
	eventKind:EventKind,
} 

abstract class BasicScene extends h2d.Scene {
	public final seidhGameEngine:SeidhGameEngine;

	public static var ActualScreenWidth = 0;
	public static var ActualScreenHeight = 0;

    public var networking:Networking;
	public var debugGraphics:h2d.Graphics;

	private var gameUiScene:GameUiScene;
	private var fui:h2d.Flow;
	private var debugText:h2d.Text;

	private var playerEntity:ClientCharacterEntity;
	private var targetCursor:h2d.Bitmap;

	private final isMobileDevice:Bool;

	private var cameraOffsetX = 0;
	private var cameraOffsetY = 0;

	private var basicSceneCallback:BasicSceneClickCallback->Void;

	// UI

	final clientCharacterEntities = new Map<String, ClientCharacterEntity>();
	// final clientProjectileEntities = new Map<String, ClientProjectileEntity>();
	
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
			// NativeWindowJS.restPostTelegramInitData(NativeWindowJS.tgGetInitData());

			new TerrainManager(this);

			this.seidhGameEngine = seidhGameEngine;

			this.seidhGameEngine.createCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
				final character = new ClientCharacterEntity(this);
				character.initiateEngineEntity(characterEntity);
				clientCharacterEntities.set(character.getId(), character);

				if (character.getOwnerId() == Player.instance.playerId) {
					playerEntity = character;
					// targetCursor = new h2d.Bitmap(hxd.Res.input.target.toTile().center(), this);
				}
			};

			this.seidhGameEngine.deleteCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
				final character = clientCharacterEntities.get(characterEntity.getId());
				if (character != null) {
					if (character.getEntityType() == EntityType.RAGNAR_LOH || 
						character.getEntityType() == EntityType.RAGNAR_NORM) {
						SceneManager.Sound.playVikingDeath();
					} else if (
						character.getEntityType() == EntityType.ZOMBIE_BOY || 
						character.getEntityType() == EntityType.ZOMBIE_GIRL) {
						SceneManager.Sound.playZombieDeath();
					}

					character.animation.setAnimationState(DEAD);
					removeChild(character);
					clientCharacterEntities.remove(characterEntity.getId());
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

			this.seidhGameEngine.postLoopCallback = function callback() {
				for (mainEntity in seidhGameEngine.getCharacterEntitiesMap()) {
					if (clientCharacterEntities.exists(mainEntity.getId())) {
						final clientEntity = clientCharacterEntities.get(mainEntity.getId());
						clientEntity.setTragetServerPosition(mainEntity.getX(), mainEntity.getY());
					}
				}

				if (networking != null) {
					for (input in seidhGameEngine.validatedInputCommands) {
						if (input.playerId == Player.instance.playerId) {
							inputsSent++;
							networking.input(input);
						}
					}
				}
			};

			this.seidhGameEngine.characterActionCallbacks = function callback(params:Array<CharacterActionCallbackParams>) {
				// TODO make callbacks work
				for (value in params) {
					// SceneManager.Sound.playZombieDeath();

					// Play action initiator animation
					final clientEntity = clientCharacterEntities.get(value.entityId);
					switch (value.actionType) {
						case CharacterActionType.ACTION_MAIN:
							if (clientEntity.getEntityType() == EntityType.RAGNAR_LOH ||
								clientEntity.getEntityType() == EntityType.RAGNAR_NORM) {
								SceneManager.Sound.playVikingHit();
							} else if (
								clientEntity.getEntityType() == EntityType.ZOMBIE_BOY ||
								clientEntity.getEntityType() == EntityType.ZOMBIE_GIRL) {
								SceneManager.Sound.playZombieHit();
							}

							clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_3);
						case CharacterActionType.ACTION_1:
							clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_1);
						default: 
					}
						// case MELEE_ATTACK_1:
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_1);
						// case MELEE_ATTACK_2:
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_2);
						// case MELEE_ATTACK_3:
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_3);
						// case RUN_ATTACK:
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_RUN);
						// case RANGED_ATTACK1:
						// 	// clientEntity.animation.setAnimationState(CharacterAnimationState.SHOT_1);
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_1);
						// case RANGED_ATTACK2:
						// 	// clientEntity.animation.setAnimationState(CharacterAnimationState.SHOT_2);
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.ATTACK_2);
						// case DEFEND:
						// 	clientEntity.animation.setAnimationState(CharacterAnimationState.DEFEND);
					// }

					// Draw shape only for melee attacks
					// clientEntity.setDebugActionShape(value.shape);

					// Play hurt and dead animations
					for (value in value.hurtEntities) {
						final clientEntity = clientCharacterEntities.get(value);
						if (clientEntity != null) {
							if (clientEntity.getEntityType() == EntityType.RAGNAR_LOH ||
								clientEntity.getEntityType() == EntityType.RAGNAR_NORM) {
								SceneManager.Sound.playVikingDmg();
							} else if (
								clientEntity.getEntityType() == EntityType.ZOMBIE_BOY ||
								clientEntity.getEntityType() == EntityType.ZOMBIE_GIRL) {
								SceneManager.Sound.playZombieDmg();
							}
							clientEntity.animation.setAnimationState(HURT);
						}
					}
					for (value in value.deadEntities) {
						final clientEntity = clientCharacterEntities.get(value);
						if (clientEntity != null) {
							clientEntity.animation.setAnimationState(DEAD);
						}
					}
				}
			};

			this.seidhGameEngine.gameStateCallback = function callback(gameState:GameState) {
				if (gameState == GameState.WIN) {
					gameUiScene.showWinDialog();
				} else {
					trace('Game Over!');
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

		hxd.Window.getInstance().addEventTarget(onEvent);

		onResize();
	}

	public abstract function start():Void;

	public abstract function customUpdate(dt:Float, fps:Float):Void;

	public function initNetwork() {
		if (networking == null) {
			networking = new Networking();
		}
	}

	public function destroy() {
		this.basicSceneCallback = null;
	}

	public function onResize() {
		final jsScreenParams = NativeWindowJS.getScreenParams();
		final screenOrientation = jsScreenParams.orientation;
		final ratio = screenOrientation == 'portrait' ? 
			jsScreenParams.pageHeight / jsScreenParams.pageWidth : 
			jsScreenParams.pageWidth / jsScreenParams.pageHeight;
		final w = ActualScreenWidth = screenOrientation == 'portrait' ? 720 : Std.int(720 * ratio);
		final h = ActualScreenHeight = screenOrientation == 'portrait' ? Std.int(720 * ratio) : 720;
		
		if (seidhGameEngine != null) {
			if (isMobileDevice) {
				if (gameUiScene == null) {
					gameUiScene = new GameUiScene(
						isMobileDevice,
						function callback(buttonPressed:ButtonPressed) {
							switch (buttonPressed) {
								case ButtonPressed.A:
									addInputCommand(CharacterActionType.ACTION_MAIN);
								// case ButtonPressed.B:
									// addInputCommand(CharacterActionType.ACTION_1);
								default:
							}
						},
						function callback(angle:Float) {
							addInputCommand(CharacterActionType.MOVE, angle);
						}
					);
				}
				gameUiScene.resize(screenOrientation, w, h);
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
			// camera.scale(0.5, 0.5);
			// scale(0.5);
			// camera.setViewport(0, 0, w, h);

			// cameraOffsetX = -Std.int(w / 2);
			// cameraOffsetY = -Std.int(h / 2);
		}
	}

	public function update(dt:Float, fps:Float) {
		debugGraphics.clear();

		if (gameUiScene != null) {
			gameUiScene.update();
		}

		updateDesktopInput();
		customUpdate(dt, fps);

		for (character in clientCharacterEntities) {
			character.update(dt);
		}

		if (playerEntity != null) {
			camera.x = playerEntity.x + cameraOffsetX;
			camera.y = playerEntity.y + cameraOffsetY;
		}
	}

	public override function render(e:Engine) {
		for (character in clientCharacterEntities) {
			if (GameConfig.DebugDraw) {
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
		final playerId = Player.instance.playerId;
		final playerEntityId = Player.instance.playerEntityId;

		final allowInput = characterActionType == CharacterActionType.MOVE ? 
		seidhGameEngine.checkLocalMovementInputAllowance(playerEntityId) :
			seidhGameEngine.checkLocalActionInputAllowance(playerEntityId, characterActionType);

		if (allowInput) {
			seidhGameEngine.addInputCommandClient(new PlayerInputCommand(characterActionType, moveAngle, playerId, Player.instance.incrementAndGetInputIndex()));
		}
	}

	// ----------------------------------
	// Entities
	// ----------------------------------

	public function createCharacterEntityFromMinimalStruct(id: String, ownerId: String, x:Int, y:Int, entityType:EntityType) {
		seidhGameEngine.createCharacterEntityFromMinimalStruct({
			id: id, 
			ownerId: ownerId, 
			x: x, 
			y: y, 
			entityType: entityType
		});
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