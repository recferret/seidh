package game.scene.base;


import h3d.Engine;
import hxd.Key in K;

import game.entity.character.ClientCharacterEntity;
import game.entity.projectile.ClientProjectileEntity;
import game.js.NativeWindowJS;
import game.network.Networking;
import game.scene.ControlsScene.ButtonPressed;
import game.utils.Utils;

import engine.base.BaseTypesAndClasses;
import engine.base.MathUtils;
import engine.base.entity.impl.EngineProjectileEntity;
import engine.base.entity.impl.EngineCharacterEntity;
import engine.base.geometry.Point;
import engine.base.geometry.Rectangle;
import engine.seidh.SeidhGameEngine;

enum abstract GameState(Int) {
	var INIT = 1;
	var PLAYING = 2;
}

typedef BasicSceneCallback = {
	clickX:Float,
	clickY:Float,
} 

class MovementController extends h2d.Object {

	private var outerCircle:h2d.Bitmap;
	private var innerCircle:h2d.Bitmap;
	private var customGraphics:h2d.Graphics;

	private var inputActive = false;
	private var camera:h2d.Camera;

	private var angle = 0.0;
	private var controlTargetPos = new Point();
	private var lastMousePos = new h2d.col.Point();
	private var callback:Float->Void;

	private var shapeRect = new Rectangle(0,0,0,0,0);

    public function new(s2d:h2d.Scene, callback:Float->Void) {
        super(s2d);

		this.callback = callback;

		camera = s2d.camera;
		customGraphics = new h2d.Graphics(s2d);

		outerCircle = new h2d.Bitmap(hxd.Res.input.cirlce_1.toTile().center(), this);
		innerCircle = new h2d.Bitmap(hxd.Res.input.circle_2.toTile().center(), this);
		
		innerCircleDefaultPos();
    }

	public function updateCursorPosition(x:Float, y:Float) {
		var p = new h2d.col.Point(x, y);
		camera.screenToCamera(p);

		if (shapeRect.containtPoint(new Point(p.x, p.y))) {
			lastMousePos.x = x;
			lastMousePos.y = y;
			camera.screenToCamera(lastMousePos);

			innerCircle.alpha = 0.7;
			inputActive = true;

			innerCircle.setPosition(controlTargetPos.x - shapeRect.x, controlTargetPos.y - shapeRect.y);
		} else {
			innerCircle.alpha = 1;
			inputActive = false;

			innerCircleDefaultPos();
		}
	}

	public function initiate(x:Float, y:Float, rectSize:Int) {
		setPosition(x, y);
		shapeRect = new Rectangle(x,y, rectSize, rectSize, 0);
	}

	public function update() {
		if (inputActive) {
			final p1 = new engine.base.geometry.Point(outerCircle.localToGlobal().x, outerCircle.localToGlobal().y);
			final p2 = new engine.base.geometry.Point(lastMousePos.x, lastMousePos.y);
			angle = MathUtils.angleBetweenPoints(p1, p2);
			callback(angle);

			controlTargetPos = MathUtils.rotatePointAroundCenter(p1.x + 80, p1.y, p1.x, p1.y, angle);

			customGraphics.clear();

			Utils.DrawRect(customGraphics, shapeRect, GameConfig.RedColor);

			customGraphics.lineStyle(2, 0xEA8220);
			customGraphics.moveTo(p1.x, p1.y);
			customGraphics.lineTo(controlTargetPos.x, controlTargetPos.y);
			customGraphics.endFill();
		} else {
			customGraphics.clear();
			Utils.DrawRect(customGraphics, shapeRect, GameConfig.RedColor);
		}
	}

	private function innerCircleDefaultPos() {
		innerCircle.setPosition(
			0, 0
		);
	}
}

abstract class BasicScene extends h2d.Scene {
	public final baseEngine:SeidhGameEngine;
    public var networking:Networking;
	public var debugGraphics:h2d.Graphics;

	private var controlsScene:ControlsScene;
	private var fui:h2d.Flow;

	private var playerEntity:ClientCharacterEntity;
	private var targetCursor:h2d.Bitmap;

	final clientCharacterEntities = new Map<String, ClientCharacterEntity>();
	final clientProjectileEntities = new Map<String, ClientProjectileEntity>();
	
	public function new(baseEngine:SeidhGameEngine, ?basicSceneCallback:BasicSceneCallback->Void) {
		super();

		onResize();

		if (baseEngine != null) {
			controlsScene = new ControlsScene(baseEngine, function callback(buttonPressed:ButtonPressed) {
				switch (buttonPressed) {
					case ButtonPressed.A:
						addInputCommand(CharacterActionType.ACTION_MAIN);
					case ButtonPressed.B:
						addInputCommand(CharacterActionType.ACTION_1);
					default:
				}
			});

			this.baseEngine = baseEngine;

			this.baseEngine.createCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
				final character = new ClientCharacterEntity(this);
				character.initiateEngineEntity(characterEntity);
				clientCharacterEntities.set(character.getId(), character);

				if (character.getOwnerId() == Player.instance.playerId) {
					playerEntity = character;
					targetCursor = new h2d.Bitmap(hxd.Res.input.target.toTile().center(), this);
				}
			};

			this.baseEngine.deleteCharacterCallback = function callback(characterEntity:EngineCharacterEntity) {
				final character = clientCharacterEntities.get(characterEntity.getId());
				if (character != null) {
					character.animation.setAnimationState(DEAD);
					clientCharacterEntities.remove(characterEntity.getId());
				}
			};

			this.baseEngine.createProjectileCallback = function callback(projectileEntity:EngineProjectileEntity) {
				final projectile = new ClientProjectileEntity(this);
				projectile.initiateEngineEntity(projectileEntity);
				clientProjectileEntities.set(projectileEntity.getId(), projectile);
			};

			this.baseEngine.deleteProjectileCallback = function callback(projectileEntity:EngineProjectileEntity) {
				final projectile = clientProjectileEntities.get(projectileEntity.getId());
				if (projectile != null) {
					// TODO play some animation 
					clientProjectileEntities.remove(projectileEntity.getId());
					removeChild(projectile);
				}
			};

			this.baseEngine.postLoopCallback = function callback() {
				for (mainEntity in baseEngine.getCharacterEntitiesMap()) {
					if (clientCharacterEntities.exists(mainEntity.getId())) {
						final clientEntity = clientCharacterEntities.get(mainEntity.getId());
						clientEntity.setTragetServerPosition(mainEntity.getX(), mainEntity.getY());
					}
				}

				if (networking != null) {
					for (input in baseEngine.validatedInputCommands) {
						if (input.playerId == Player.instance.playerId) {
							networking.sendInput(input);
						}
					}
				}
			};

			this.baseEngine.characterActionCallbacks = function callback(params:Array<CharacterActionCallbackParams>) {
				for (value in params) {
					// Play action initiator animation
					final clientEntity = clientCharacterEntities.get(value.entityId);
					switch (value.actionType) {
						case CharacterActionType.ACTION_MAIN:
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
					clientEntity.setDebugActionShape(value.shape);

					// Play hurt and dead animations
					for (value in value.hurtEntities) {
						final clientEntity = clientCharacterEntities.get(value);
						if (clientEntity != null) {
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
		}

		debugGraphics = new h2d.Graphics(this);
		addChild(debugGraphics);

		fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = 5;
		fui.padding = 10;

		function onEvent(event:hxd.Event) {
			if (controlsScene != null) {
				if (event.kind == EMove) {
					controlsScene.updateCursorPosition(event.relX, event.relY);
				} else if (event.kind == ERelease) {
					controlsScene.release();
				} else {
					if (event.kind == EPush && basicSceneCallback != null) {
						final clickPos = new h2d.col.Point(event.relX, event.relY);
						camera.screenToCamera(clickPos);
						basicSceneCallback({
							clickX: clickPos.x,
							clickY: clickPos.y
						});
					}
				}
			}
		}

		hxd.Window.getInstance().addEventTarget(onEvent);
	}

	public abstract function start():Void;

	public abstract function customUpdate(dt:Float, fps:Float):Void;

	public function initNetwork() {
		if (networking == null) 
			networking = new Networking();
	}

	public function onResize() {
		final mobile = NativeWindowJS.getMobile();
		var isMobile = false;

		if (mobile != null) {
			if (mobile != 'null' || mobile != 'undefined') {
				isMobile = true;
			}
		}

		var w = 0;
		var h = 0;

		if (isMobile) {
			final jsScreenParams = NativeWindowJS.getScreenParams();

			if (jsScreenParams.orientation == 'portrait') {
				final ratio1 = jsScreenParams.screenHeight / jsScreenParams.screenWidth;				// 2.21
				final ratio2 = jsScreenParams.windowOuterHeight / jsScreenParams.windowOuterWidth;		// 1.84
				final ratio3 = ratio1 - ratio2;															// 0.37
				h = 720;
				w = Std.int(h * (ratio1 + ratio3));
				scaleMode = ScaleMode.Stretch(h, w);

				// TODO ask user to play landscape ?
				// camera.setViewport(Std.int(w / 2), Std.int(h / 2.5), w, h);
			} else {
				final ratio = jsScreenParams.windowOuterWidth / jsScreenParams.windowOuterHeight;		// 1.84
				h = 720;
				w = Std.int(h * (ratio));
				scaleMode = ScaleMode.Stretch(w, h);

				camera.setViewport(Std.int(w / 2), Std.int(h / 2.5), w, h);

				camera.scale(2, 2);
			}
		} else {
			w = hxd.Window.getInstance().width;
			h = hxd.Window.getInstance().height;
			final ratio = 720 * (w / h);
			final targetWidth = Std.int(ratio);
			final targetHeight = 720;

			scaleMode = ScaleMode.Stretch(targetWidth, targetHeight);

			camera.setViewport(Std.int(targetWidth / 2), Std.int(targetHeight / 3), targetWidth, targetHeight);
		}
	}

	public function update(dt:Float, fps:Float) {
		debugGraphics.clear();

		if (controlsScene != null) {
			controlsScene.update();
		}

		updateInput();
		customUpdate(dt, fps);

		for (projectile in clientProjectileEntities) {
			projectile.update(dt);
		}

		for (character in clientCharacterEntities) {
			character.update(dt);
		}

		if (playerEntity != null) {
			camera.x = playerEntity.x;
			camera.y = playerEntity.y;

			// TODO smooth movement

			final line = playerEntity.getForwardLookingLine(80);	
			targetCursor.setPosition(line.p2.x, line.p2.y);
		}
		
		// var y = 0;
		// for (i in 0...13) {
		// 	Utils.DrawLine(debugGraphics, new h2d.col.Point(0, y), new h2d.col.Point(64 * 12, y), GameConfig.RedColor);
		// 	y += 64;
		// }

		// var x = 0;
		// for (i in 0...13) {
		// 	Utils.DrawLine(debugGraphics, new h2d.col.Point(x, 0), new h2d.col.Point(x, 64 * 12), GameConfig.RedColor);
		// 	x += 64;
		// }
	}

	public override function render(e:Engine) {
		if (controlsScene != null) {
			controlsScene.render(e);
		}
		for (projectile in clientProjectileEntities) {
			if (GameConfig.DebugDraw) {
				projectile.debugDraw(debugGraphics);
			}
		}

		for (character in clientCharacterEntities) {
			if (GameConfig.DebugDraw) {
				character.debugDraw(debugGraphics);
			}
		}
		super.render(e);
	}

	public function getInputScene():h2d.Scene {
		return controlsScene != null ? controlsScene : this;
	}

	private function updateInput() {
		final space = K.isDown(K.SPACE);
		final backspace = K.isDown(K.BACKSPACE);
		var playerActionInputType:CharacterActionType = null;

		if (space) {
			playerActionInputType = CharacterActionType.ACTION_MAIN;
		} else if (backspace) {
			playerActionInputType = CharacterActionType.ACTION_1;
		}

		addInputCommand(playerActionInputType);
	}

	private function addInputCommand(characterActionType:CharacterActionType) {
		final playerId = Player.instance.playerId;
		final playerEntityId = Player.instance.playerEntityId;

		if (characterActionType != null) {
			final actionAllowance = baseEngine.checkLocalActionInputAllowance(playerEntityId, characterActionType);
			if (characterActionType != null && actionAllowance) {
				baseEngine.addInputCommandClient(new PlayerInputCommand(characterActionType, 0, playerId, Player.instance.incrementAndGetInputIndex()));
			}
		}
	}

	// ----------------------------------
	// Entities
	// ----------------------------------

	public function createCharacterEntityFromMinimalStruct(id: String, ownerId: String, x:Int, y:Int, entityType:EntityType) {
		baseEngine.createCharacterEntityFromMinimalStruct({
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
		var f = new h2d.Flow(fui);
		f.padding = 25;
		f.paddingBottom = 7;
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
		text.text = label;
		return text;
	}
}