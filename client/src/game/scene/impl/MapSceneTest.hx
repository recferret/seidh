package game.scene.impl;

import h3d.Engine;
import hxd.Key in K;

import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.factory.SeidhEntityFactory;

import game.utils.Utils;
import game.entity.character.ClientCharacterEntity;
import game.scene.base.BasicScene;
import game.terrain.TerrainManager;


class MapSceneTest extends BasicScene {

	private var characters:Array<ClientCharacterEntity> = new Array<ClientCharacterEntity>();
	private var terrainManager:TerrainManager;

	private var cameraOffsetX = 0;
	private var cameraOffsetY = 0;

    public function new() {
		super(null);

		terrainManager = new TerrainManager(this);

		camera.setScale(0.35, 0.35);
		camera.setPosition(1200, 1200);

		var zombieX = 2500;
		var zombieY = 1550;

		characters.push(new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter({
			x: zombieX,
			y: zombieY,
			entityType: EntityType.RAGNAR_LOH,
		})));


		// for (x in 1...11) {
			// for (y in 1...11) {
			// 	characters.push(new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter({
			// 			x: zombieX,
			// 			y: zombieY,
			// 			entityType: EntityType.ZOMBIE_BOY,
			// 		})
			// 	));
			// 	zombieY += 200;
			// }
			zombieX += 200;
			zombieY = 2650;
		// }
	}	

	// --------------------------------------
	// Abstraction
	// --------------------------------------

    public function absOnEvent(event:hxd.Event) {
    }

    public function absOnResize(w:Int, h:Int) {
    }

	public function absStart() {
    }

	public function absUpdate(dt:Float, fps:Float) {
		final camLeft = K.isDown(K.LEFT);
		final camRight = K.isDown(K.RIGHT);
		final camUp = K.isDown(K.UP);
		final camDown = K.isDown(K.DOWN);

		if (camLeft) {
            cameraOffsetX -= 15;
        }
        if (camRight) {
            cameraOffsetX += 15;
        }
        if (camUp) {
            cameraOffsetY -= 15;
        }
        if (camDown) {
            cameraOffsetY += 15;
        }

		camera.setPosition(camera.x + cameraOffsetX, camera.y + cameraOffsetY);

		cameraOffsetX = 0;
		cameraOffsetY = 0;

		final charLeft = K.isDown(K.A);
		final charRight = K.isDown(K.D);
		final charUp = K.isDown(K.W);
		final charDown = K.isDown(K.S);

		final charIndex = 0;

        if (charLeft) {
            characters[charIndex].x -= 5;
        }
        if (charRight) {
            characters[charIndex].x += 5;
        }
        if (charUp) {
            characters[charIndex].y -= 5;
        }
        if (charDown) {
            characters[charIndex].y += 5;
        }

		final characterToEnvIntersections = new Array<Dynamic>();
		final processedTerrainEntities = new Array<Int>();

		for (character in characters) {
			characterToEnvIntersections.push(character);

			Utils.DrawRect(debugGraphics, character.getRect(), GameClientConfig.BlueColor);
			Utils.DrawRect(debugGraphics, character.getBottomRect(), GameClientConfig.GreenColor);

			// final ragnarBottom = character.getBottomRect().getCenter();
			final characterRect = character.getRect();

			for (terrain in terrainManager.terrainArray) {
				if (!processedTerrainEntities.contains(terrain.getId())) {
					processedTerrainEntities.push(terrain.getId());

					// final treeBottom = tree.getBottomRect().getCenter();
					final terrainRect = terrain.getRect();

					Utils.DrawRect(debugGraphics, terrain.getRect(), GameClientConfig.BlueColor);
					Utils.DrawRect(debugGraphics, terrain.getBottomRect(), GameClientConfig.GreenColor);

					if (terrainRect.getCenter().distance(characterRect.getCenter()) < 200) {
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
		}

		sortObjectsByZOrder();
	}

    public function absRender(e:Engine) {
    }
    
    public function absDestroy() {
    }


}