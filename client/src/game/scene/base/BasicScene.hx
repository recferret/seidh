package game.scene.base;

import h2d.Scene.ScaleMode;
import engine.base.geometry.Rectangle;
import game.utils.Utils;
import engine.base.MathUtils;
import game.network.Networking;
import game.entity.KnightEntity;
import game.entity.SamuraiEntity;
import game.entity.SkeletonWarriorEntity;
import game.entity.SkeletonArcherEntity;
import game.entity.BaseClientEntity;
import engine.base.BaseTypesAndClasses;
import engine.base.entity.EngineBaseGameEntity;
import engine.base.geometry.Point;
import engine.holy.HolyGameEngine;
import hxd.Key in K;

enum abstract GameState(Int) {
	var INIT = 1;
	var PLAYING = 2;
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
	public final baseEngine:HolyGameEngine;
    public var networking:Networking;
	public var debugGraphics:h2d.Graphics;

	private var movementController:MovementController;
	private var fui:h2d.Flow;

	final clientMainEntities = new Map<String, BaseClientEntity>();

	public function new(baseEngine:HolyGameEngine) {
		super();

		scaleMode = ScaleMode.LetterBox(1280, 720, true, Left, Top);

		if (baseEngine != null) {
			movementController = new MovementController(this, function callback(angle:Float) {
				// TODO pass input here
				trace(angle);

				final playerId = Player.instance.playerId;
				final playerEntityId = Player.instance.playerEntityId;
				final playerMovementInputType = PlayerInputType.MOVE_DIR;

				if (playerMovementInputType != null) {
					final movementAllowance = baseEngine.checkLocalMovementInputAllowance(playerEntityId, playerMovementInputType);
					if (movementAllowance) {
						baseEngine.addInputCommandClient(new PlayerInputCommand(playerMovementInputType, angle, playerId, Player.instance.incrementAndGetInputIndex()));
					}
				}
			});
  
			movementController.initiate(150, 720 - 150, 300);

			this.baseEngine = baseEngine;
			this.baseEngine.createMainEntityCallback = function callback(engineEntity:EngineBaseGameEntity) {
				var entity: BaseClientEntity = null;

				switch (engineEntity.getEntityType()) {
					case KNIGHT:
						entity = new KnightEntity(this);
					case SAMURAI:
						entity = new SamuraiEntity(this);
					case SKELETON_WARRIOR:	
						entity = new SkeletonWarriorEntity(this);
					case SKELETON_ARCHER:	
						entity = new SkeletonArcherEntity(this);
					default:	
				}

				entity.initiateEngineEntity(engineEntity);
				clientMainEntities.set(entity.getId(), entity);
			};

			this.baseEngine.deleteMainEntityCallback = function callback(engineEntity:EngineBaseGameEntity) {
				final entity = clientMainEntities.get(engineEntity.getId());
				if (entity != null) {
					entity.animation.setAnimationState(DEAD);
					clientMainEntities.remove(engineEntity.getId());
				}
			};

			this.baseEngine.postLoopCallback = function callback() {
				// Only for players and local mode ?
				for (mainEntity in baseEngine.getMainEntities()) {
					if (clientMainEntities.exists(mainEntity.getId())) {
						final clientEntity = clientMainEntities.get(mainEntity.getId());
						clientEntity.setTragetServerPosition(mainEntity.getX(), mainEntity.getY());
					}
				}

				if (networking != null) {
					for (input in baseEngine.validatedInputCommands) {
						if (input.playerId == Player.instance.playerId) {
							networking.sendInput(input.inputType);
						}
					}
				}
			};

			this.baseEngine.entityActionCallback = function callback(params:Array<EntityActionCallbackParams>) {
				for (value in params) {
					// Play action initiator animation
					final clientEntity = clientMainEntities.get(value.entityId);
					switch (value.actionType) {
						case MELEE_ATTACK_1:
							clientEntity.animation.setAnimationState(EntityAnimationState.ATTACK_1);
						case MELEE_ATTACK_2:
							clientEntity.animation.setAnimationState(EntityAnimationState.ATTACK_2);
						case MELEE_ATTACK_3:
							clientEntity.animation.setAnimationState(EntityAnimationState.ATTACK_3);
						case RUN_ATTACK:
							clientEntity.animation.setAnimationState(EntityAnimationState.ATTACK_RUN);
						case RANGED_ATTACK1:
							clientEntity.animation.setAnimationState(EntityAnimationState.SHOT_1);
						case RANGED_ATTACK2:
							clientEntity.animation.setAnimationState(EntityAnimationState.SHOT_2);
						case DEFEND:
							clientEntity.animation.setAnimationState(EntityAnimationState.DEFEND);
					}
					clientEntity.setDebugActionShape(value.shape);

					// Play hurt and dead animations
					for (value in value.hurtEntities) {
						final clientEntity = clientMainEntities.get(value);
						if (clientEntity != null) {
							clientEntity.animation.setAnimationState(HURT);
						}
					}
					for (value in value.deadEntities) {
						final clientEntity = clientMainEntities.get(value);
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
			if (event.kind == EMove) {
				movementController.updateCursorPosition(event.relX, event.relY);
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

	public function update(dt:Float, fps:Float) {
		movementController.update();
		updateInput();
		customUpdate(dt, fps);
	}

	public function getInputScene():h2d.Scene {
		return this;
	}

	private function updateInput() {
		final left = K.isDown(K.LEFT);
		final right = K.isDown(K.RIGHT);
		final up = K.isDown(K.UP);
		final down = K.isDown(K.DOWN);
		final space = K.isDown(K.SPACE);

		var playerMovementInputType:PlayerInputType = null;
		var playerActionInputType:PlayerInputType = null;

		if (up) {
			if (left) {
				playerMovementInputType = PlayerInputType.MOVE_UP_LEFT;
			} else if (right) {
				playerMovementInputType = PlayerInputType.MOVE_UP_RIGHT;
			} else  {
				playerMovementInputType = PlayerInputType.MOVE_UP;
			}
		} else if(down) {
			if (left) {
				playerMovementInputType = PlayerInputType.MOVE_DOWN_LEFT;
			} else if (right) {
				playerMovementInputType = PlayerInputType.MOVE_DOWN_RIGHT;
			} else  {
				playerMovementInputType = PlayerInputType.MOVE_DOWN;
			}
		} else if (left) {
			if (up) {
				playerMovementInputType = PlayerInputType.MOVE_UP_LEFT;
			} else if (down) {
				playerMovementInputType = PlayerInputType.MOVE_DOWN_LEFT;
			} else {
				playerMovementInputType = PlayerInputType.MOVE_LEFT;
			}
		} else if (right) {
			if (up) {
				playerMovementInputType = PlayerInputType.MOVE_UP_RIGHT;
			} else if (down) {
				playerMovementInputType = PlayerInputType.MOVE_DOWN_RIGHT;
			} else {
				playerMovementInputType = PlayerInputType.MOVE_RIGHT;
			}
		}

		if (space) {
			playerActionInputType = PlayerInputType.MELEE_ATTACK;
		}

		final playerId = Player.instance.playerId;
		final playerEntityId = Player.instance.playerEntityId;

		if (playerMovementInputType != null) {
			final movementAllowance = baseEngine.checkLocalMovementInputAllowance(playerEntityId, playerMovementInputType);
			if (playerMovementInputType != null && (up || down || left || right) && movementAllowance) {
				baseEngine.addInputCommandClient(new PlayerInputCommand(playerMovementInputType, 0, playerId, Player.instance.incrementAndGetInputIndex()));
			}
		}

		if (playerActionInputType != null) {
			final actionAllowance = baseEngine.checkLocalActionInputAllowance(playerEntityId, playerActionInputType);
			if (playerActionInputType != null && (space) && actionAllowance) {
				baseEngine.addInputCommandClient(new PlayerInputCommand(playerActionInputType, 0, playerId, Player.instance.incrementAndGetInputIndex()));
			}
		}
	}

	// ----------------------------------
	// Entities
	// ----------------------------------

	public function createGameEntityFromMinimalStruct(id: String, ownerId: String, x:Int, y:Int, entityType:EntityType) {
		baseEngine.buildEngineEntityFromMinimalStruct({
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

	// TODO move to separate class

	private function getFont() {
		return hxd.res.DefaultFont.get();
	}

	public function addButton(label: String, onClick: h2d.Flow -> Void) {
		var f = new h2d.Flow(fui);
		f.padding = 25;
		f.paddingBottom = 7;
		f.backgroundTile = h2d.Tile.fromColor(0x404040);
		var tf = new h2d.Text(getFont(), f);
		tf.text = label;
		f.enableInteractive = true;
		f.interactive.cursor = Button;
		f.interactive.onClick = function(_) onClick(f);
		f.interactive.onOver = function(_) f.backgroundTile = h2d.Tile.fromColor(0x606060);
		f.interactive.onOut = function(_) f.backgroundTile = h2d.Tile.fromColor(0x404040);
		return f;
	}
}