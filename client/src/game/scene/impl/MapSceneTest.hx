package game.scene.impl;

import game.utils.Utils;
import engine.seidh.entity.factory.SeidhEntityFactory;
import engine.base.BaseTypesAndClasses.EntityType;
import game.entity.character.ClientCharacterEntity;
import game.scene.base.BasicScene;
import game.terrain.TerrainManager;

import hxd.Key in K;

class MapSceneTest extends BasicScene {

	private var characters:Array<ClientCharacterEntity> = new Array<ClientCharacterEntity>();

	private var cameraOffsetX = 0;
	private var cameraOffsetY = 0;

    public function new() {
		super(null);

		terrainManager = new TerrainManager(this);

		camera.setScale(0.35, 0.35);
		camera.setPosition(1200, 1200);

		// characters.push(new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter(null, null, 2100, 2650, EntityType.RAGNAR_LOH)));

		var zombieX = 2500;
		var zombieY = 1550;
		// for (x in 1...11) {
			for (y in 1...11) {
				characters.push(new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter(null, null, zombieX, zombieY, EntityType.ZOMBIE_BOY)));
				zombieY += 200;
			}
			zombieX += 200;
			zombieY = 2650;
		// }
	}	

	// --------------------------------------
	// Impl
	// --------------------------------------

	public function start() {
	}

	public function customUpdate(dt:Float, fps:Float) {
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

		for (index => character in characters) {
			characterToEnvIntersections.push(character);

			Utils.DrawRect(debugGraphics, character.getRect(), GameConfig.BlueColor);
			Utils.DrawRect(debugGraphics, character.getBottomRect(), GameConfig.GreenColor);

			// final ragnarBottom = character.getBottomRect().getCenter();
			final characterRect = character.getRect();

			for (index => terrain in terrainManager.terrainArray) {
				// final treeBottom = tree.getBottomRect().getCenter();
				final terrainRect = terrain.getRect();

				Utils.DrawRect(debugGraphics, terrain.getRect(), GameConfig.BlueColor);
				Utils.DrawRect(debugGraphics, terrain.getBottomRect(), GameConfig.GreenColor);

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
							env.oZrder = index;
						}
					}
				}
			}
		}

		sortObjectsByZOrder();
	}

}