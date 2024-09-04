package game.scene.impl;

import game.utils.Utils;
import engine.seidh.entity.factory.SeidhEntityFactory;
import engine.base.BaseTypesAndClasses.EntityType;
import game.entity.character.ClientCharacterEntity;
import game.scene.base.BasicScene;
import game.terrain.TerrainManager2;

import hxd.Key in K;

class MapSceneTest extends BasicScene {

	private var characters:Array<ClientCharacterEntity> = new Array<ClientCharacterEntity>();

	private var terrainManager2:TerrainManager2;

	private var cameraOffsetX = 0;
	private var cameraOffsetY = 0;

    public function new() {
		super(null);

		terrainManager2 = new TerrainManager2(this);

		camera.setScale(0.35, 0.35);
		camera.setPosition(1200, 2000);

		// characters.push(new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter(null, null, 2000, 2800, EntityType.RAGNAR_LOH)));

		characters.push(new ClientCharacterEntity(this, SeidhEntityFactory.InitiateCharacter(null, null, 1600, 2400, EntityType.ZOMBIE_BOY)));
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

        if (charLeft) {
            characters[0].x -= 5;
        }
        if (charRight) {
            characters[0].x += 5;
        }
        if (charUp) {
            characters[0].y -= 5;
        }
        if (charDown) {
            characters[0].y += 5;
        }

		final characterToEnvIntersections = new Array<Dynamic>();

		for (index => character in characters) {
			characterToEnvIntersections.push(character);

			Utils.DrawRect(debugGraphics, character.getRect(), GameConfig.BlueColor);
			Utils.DrawRect(debugGraphics, character.getBottomRect(), GameConfig.GreenColor);

			// final ragnarBottom = character.getBottomRect().getCenter();
			final characterRect = character.getRect();

			for (index => tree in terrainManager2.terrainArray) {
				// final treeBottom = tree.getBottomRect().getCenter();
				final treeRect = tree.getRect();

				if (treeRect.intersectsWithRect(characterRect)) {
					characterToEnvIntersections.push(tree);
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

		sortObjectsByZOrder();
	}

}