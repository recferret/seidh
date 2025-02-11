package engine.seidh;

import engine.base.EngineConfig;
import engine.base.MathUtils;
import engine.base.geometry.Point;
import engine.base.types.TypesBaseEntity;
import engine.seidh.types.TypesSeidhGame;

typedef SpawnMonster = {
	spawn:Bool,
    ?positionX:Int,
    ?positionY:Int,
    ?entityType:EntityType,
}

class AiManager {

    private final winCondition:WinCondition;
    private final monstersSpawnPoints = new Array<Point>();

    private var allowSpawnMonsters = false;
    private var allowSpawnBoss = false;
    private var bossSpawned = false;
    private var bossKilled = false;
    private var monstersMax = EngineConfig.MONSTERS_MAX;
    private var monstersLeft = EngineConfig.MONSTERS_MAX;

    private var monstersSpawned = 0;
    private var monstersLastSpawnTime = 0.0;
    private var monstersSpawnDelayMs = EngineConfig.MONSTERS_SPAWN_DELAY;
    private var bossSpawnDelay = 3;
    private var bossSpawnStartCount = 0;
    private var secondsPassed = 0;

    public function new(winCondition:WinCondition) {
        this.winCondition = winCondition;

        // Top
        for (x in 0...26) {
            monstersSpawnPoints.push(new Point(200 * x, -200));
        }

        // Bottom
        for (x in 0...26) {
            monstersSpawnPoints.push(new Point(200 * x, 5200));
        }

        // Left
        for (y in 0...26) {
            monstersSpawnPoints.push(new Point(-200, 200 * y));
        }

        // Right
        for (y in 0...26) {
            monstersSpawnPoints.push(new Point(5200, 200 * y));
        }
    }

    public function secondPassed() {
        monstersMax = EngineConfig.MONSTERS_MAX;
        monstersSpawnDelayMs = EngineConfig.MONSTERS_SPAWN_DELAY;
        allowSpawnMonsters = EngineConfig.MONSTERS_SPAWN_ENABLED;

        secondsPassed++;

        if (allowSpawnBoss) {
            bossSpawnStartCount++;
        }
        // switch (secondsPassed) {
        //     case 13:
        //         mobSpawnDelayMs = 2.000;
        //     case 34:
        //         mobSpawnDelayMs = 1.500;
        //     case 55:
        //         mobSpawnDelayMs = 1.000;
        //     case 89:
        //         mobSpawnDelayMs = 0.500;
        // }
    }

    public function spawnMonster(playerX:Int, playerY:Int) {
        final result: SpawnMonster = {
            spawn: false,
        };

        if (allowSpawnMonsters) {
            final now = haxe.Timer.stamp();

            if (!bossSpawned && monstersLeft == 0 && winCondition == WinCondition.KILL_MONSTERS_AND_BOSS) {
                if (bossSpawnStartCount == bossSpawnDelay) {
                    bossSpawned = true;

                    result.spawn = true;
                    result.entityType = EntityType.GLAMR;
                    result.positionX = playerX;
                    result.positionY = playerY - 1000;

                    return result;
                }
            } else if (monstersSpawned < monstersMax && (monstersLastSpawnTime == 0 || monstersLastSpawnTime + monstersSpawnDelayMs < now)) {
                monstersLastSpawnTime = now;
                monstersSpawned++;

                final monsterSpawnPoint = new Point(0, 0);
                final spawnDirection = MathUtils.randomIntInRange(1, 4);
                final leftOrRight = MathUtils.randomIntInRange(1, 2);
                final upOrDown = MathUtils.randomIntInRange(1, 2);
    
                switch (spawnDirection) {
                    // спавн над игроком
                    case 1:
                        if (leftOrRight == 1) {
                            monsterSpawnPoint.x = playerX - MathUtils.randomIntInRange(1, 400);
                        } else {
                            monsterSpawnPoint.x = playerX + MathUtils.randomIntInRange(1, 400);
                        }
                        monsterSpawnPoint.y = playerY - 400;
                    // спавн под игроком
                    case 2:
                        if (leftOrRight == 1) {
                            monsterSpawnPoint.x = playerX - MathUtils.randomIntInRange(1, 400);
                        } else {
                            monsterSpawnPoint.x = playerX + MathUtils.randomIntInRange(1, 400);
                        }
                        monsterSpawnPoint.y = playerY + 400;
                    // спавн слева от игрока
                    case 3:
                        monsterSpawnPoint.x = playerX - 400;
                        if (upOrDown == 1) {
                            monsterSpawnPoint.y = playerY - MathUtils.randomIntInRange(1, 400);
                        } else {
                            monsterSpawnPoint.y = playerY + MathUtils.randomIntInRange(1, 400);
                        }
                    // спавн справа от игрока
                    case 4:
                        monsterSpawnPoint.x = playerX + 400;
                        if (upOrDown == 1) {
                            monsterSpawnPoint.y = playerY - MathUtils.randomIntInRange(1, 400);
                        } else {
                            monsterSpawnPoint.y = playerY + MathUtils.randomIntInRange(1, 400);
                        }
                }
    
                result.spawn = true;
                result.entityType = EntityType.ZOMBIE_BOY;
                result.entityType = MathUtils.randomIntInRange(1, 2) == 1 ? EntityType.ZOMBIE_BOY : EntityType.ZOMBIE_GIRL;
                result.positionX = Std.int(monsterSpawnPoint.x);
                result.positionY = Std.int(monsterSpawnPoint.y);
            }
        }

        return result;
    }

    public function spawnMonstersAroundPoint(x:Float, y:Float, monstersToSpawn:Int) {
        final monsters = new Array<SpawnMonster>();

        for (i in 0...monstersToSpawn) {
            final leftOrRight = MathUtils.randomIntInRange(1, 2);
            final upOrDown = MathUtils.randomIntInRange(1, 2);

            final xRnd = MathUtils.randomIntInRange(1, 10) * 100;
            final yRnd = MathUtils.randomIntInRange(1, 10) * 100;

            final monsterSpawnPoint = new Point(
                leftOrRight == 1 ? x + xRnd : x - xRnd,
                upOrDown == 1 ? y + yRnd : y - yRnd,
            ); 

            monsters.push({
                spawn: true,
                positionX: Std.int(monsterSpawnPoint.x),
                positionY: Std.int(monsterSpawnPoint.y),
                entityType: MathUtils.randomIntInRange(1, 2) == 1 ? EntityType.ZOMBIE_BOY : EntityType.ZOMBIE_GIRL,
            });

            monstersSpawned++;
            monstersLeft++;
        }

        return monsters;
    }

    public function monsterKilled() {
        monstersLeft--;

        if (!allowSpawnBoss && monstersLeft == 0 && winCondition == WinCondition.KILL_MONSTERS_AND_BOSS) {
            allowSpawnBoss = true;
        }
    }

    public function cleanMonsters() {
        monstersLeft = 0;
        monstersSpawned = 0;
    }

    public function setBossKilled() {
        bossKilled = true;
    }

    public function allMonstersKilled() {
        if (winCondition == WinCondition.KILL_MONSTERS && monstersLeft == 0) {
            return true;
        }
        if (winCondition == WinCondition.KILL_MONSTERS_AND_BOSS && bossKilled && monstersLeft == 0) {
            return true;
        }

        return false;
    }

    // Getters

    public function getMonstersSpawnPoints() {
        return monstersSpawnPoints;
    }

    public function getMonstersMax() {
        return monstersMax;
    }

    public function getMonstersLeft() {
        return monstersLeft;
    }

    public function getMonstersSpawned() {
        return monstersSpawned;
    }

    // Setters

    public function setAllowSpawnMonsters(allowSpawnMonsters:Bool) {
        this.allowSpawnMonsters = allowSpawnMonsters;
    }

    public function setMonstersMax(monstersMax:Int) {
        this.monstersMax = monstersMax;
    }

}