package game.scene.impl;

import h3d.Engine;
import game.analytics.Analytics;
import engine.seidh.SeidhGameEngine;

import game.js.NativeWindowJS;
import game.event.EventManager;
import game.scene.base.BasicScene;

class LoadingScene extends BasicScene {

    public function new() {
        super(null);
    }

	// --------------------------------------
	// Abstraction
	// --------------------------------------

    public function absOnEvent(event:hxd.Event) {
    }

    public function absOnResize(w:Int, h:Int) {
    }

	public function absStart() {
        if (GameClientConfig.instance.Analytics) {
            // NativeWindowJS.tgInitAnalytics();
            // NativeWindowJS.telemetreeInit();
            // Analytics.instance.telemetreeInit();
        }

        switch (GameClientConfig.instance.Platform) {
            case 'VK':
                vkInit();
            case 'TG':
                tgInit();
            default:
                simpleInit();
        }
    }

	public function absUpdate(dt:Float, fps:Float) {
	}

    public function absRender(e:Engine) {
    }
    
    public function absDestroy() {
    }

    // --------------------------------------
	// Networking
	// --------------------------------------

    // TODO implement different requests
    private function vkInit() {
        NativeWindowJS.vkGetAppParams(function callback(data:Dynamic) {
            NativeWindowJS.networkInitVk(data, 
                function userCallback(data:Dynamic) {
                    processUserCallback(data);
                },
                function boostCallback(data:Dynamic) {
                    processBoostCallback(data);
                },
                function getGameConfigCallback(data:Dynamic) {
                    processGetGameConfigCallback(data);
                },
                function getCharactersDefaultParamsCallback(data:Dynamic) {
                    processGetCharactersDefaultParamsCallback(data);
                },
            );
        });
    }

    private function tgInit() {
        // final tgUnsafeData = NativeWindowJS.tgGetInitDataUnsafe();
        // final startParam = tgUnsafeData.start_param;

        NativeWindowJS.networkInitTg(NativeWindowJS.tgGetInitData(), 
            function userCallback(data:Dynamic) {
                processUserCallback(data);
            },
            function boostCallback(data:Dynamic) {
                processBoostCallback(data);
            },
            function getGameConfigCallback(data:Dynamic) {
                processGetGameConfigCallback(data);
            },
            function getCharactersDefaultParamsCallback(data:Dynamic) {
                processGetCharactersDefaultParamsCallback(data);
            },
        );
    }

    private function simpleInit() {
        NativeWindowJS.networkInitSimple(GameClientConfig.instance.TestLogin, 
            function userCallback(data:Dynamic) {
                processUserCallback(data);
            },
            function boostCallback(data:Dynamic) {
                processBoostCallback(data);
            },
            function getGameConfigCallback(data:Dynamic) {
                processGetGameConfigCallback(data);
            },
            function getCharactersDefaultParamsCallback(data:Dynamic) {
                processGetCharactersDefaultParamsCallback(data);
            },
        );
    }

    // --------------------------------------
	// Response callbacks
	// --------------------------------------

    private function processUserCallback(data:Dynamic) {
        if (data != null) {
            Player.instance.setUserData(data);
            EventManager.instance.notify(EventManager.EVENT_HOME_SCENE, {});
        } else {
            trace('processUserCallback error');
        }
    }

    private function processBoostCallback(data:Dynamic) {
        if (data != null) {
            Player.instance.setBoostData(data);
        } else {
            trace('processBoostCallback error');
        }
    }

    private function processGetGameConfigCallback(data:Dynamic) {
        if (data != null) {
            // Mobs spawn
            SeidhGameEngine.GAME_CONFIG.monstersMaxAtTheSameTime = data.monstersMaxAtTheSameTime;
            SeidhGameEngine.GAME_CONFIG.monstersMaxPerGame = data.monstersMaxPerGame;
            SeidhGameEngine.GAME_CONFIG.monstersSpawnDelayMs = data.monstersSpawnDelayMs;

            // Exp boost
            SeidhGameEngine.GAME_CONFIG.expLevel1Multiplier = data.expLevel1Multiplier;
            SeidhGameEngine.GAME_CONFIG.expLevel2Multiplier = data.expLevel2Multiplier;
            SeidhGameEngine.GAME_CONFIG.expLevel3Multiplier = data.expLevel3Multiplier;

            // Stats boost
            SeidhGameEngine.GAME_CONFIG.statsLevel1Multiplier = data.statsLevel1Multiplier;
            SeidhGameEngine.GAME_CONFIG.statsLevel2Multiplier = data.statsLevel2Multiplier;
            SeidhGameEngine.GAME_CONFIG.statsLevel3Multiplier = data.statsLevel3Multiplier;

            // Wealth boost
            SeidhGameEngine.GAME_CONFIG.wealthLevel1PickUpRangeMultiplier = data.wealthLevel1PickUpRangeMultiplier;
            SeidhGameEngine.GAME_CONFIG.wealthLevel2PickUpRangeMultiplier = data.wealthLevel2PickUpRangeMultiplier;
            SeidhGameEngine.GAME_CONFIG.wealthLevel3PickUpRangeMultiplier = data.wealthLevel3PickUpRangeMultiplier;

            SeidhGameEngine.GAME_CONFIG.wealthLevel1CoinsMultiplier = data.wealthLevel1CoinsMultiplier;
            SeidhGameEngine.GAME_CONFIG.wealthLevel2CoinsMultiplier = data.wealthLevel2CoinsMultiplier;
            SeidhGameEngine.GAME_CONFIG.wealthLevel3CoinsMultiplier = data.wealthLevel3CoinsMultiplier;
        } else {
            trace('processGetGameConfigCallback error');
        }
    }

    private function processGetCharactersDefaultParamsCallback(data:Dynamic) {
        if (data != null) {
            // SeidhGameEngine.CHARACTERS_CONFIG.ragnarLoh = data.ragnarLoh;
            // SeidhGameEngine.CHARACTERS_CONFIG.zombieBoy = data.zombieBoy;
            // SeidhGameEngine.CHARACTERS_CONFIG.zombieGirl = data.zombieGirl;
        } else {
            trace('processGetCharactersDefaultParamsCallback error');
        }
    }

}
