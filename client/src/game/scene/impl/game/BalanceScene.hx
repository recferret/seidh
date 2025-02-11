package game.scene.impl.game;

import engine.base.types.TypesBaseEntity.EntityType;
import engine.seidh.types.TypesSeidhGame;
import engine.base.types.TypesBaseEngine.EngineMode;

import game.event.EventManager;

class BalanceScene extends GameScene {

    public function new() {
        super(EngineMode.CLIENT_SINGLEPLAYER, WinCondition.KILL_MONSTERS_AND_BOSS);

        EventManager.instance.notify(EventManager.EVENT_SPAWN_CONSUMABLE, {
            entityType: EntityType.HEALTH_POTION,
        });

        // EventManager.instance.notify(EventManager.EVENT_SPAWN_CHARACTER, {
        //     // entityType: EntityType.ZOMBIE_GIRL,
        //     entityType: EntityType.GLAMR,
        // });
    }

}