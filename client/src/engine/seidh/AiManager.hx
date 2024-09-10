package engine.seidh;

import engine.base.BaseTypesAndClasses.EntityType;
import engine.base.MathUtils;
import engine.base.geometry.Point;

typedef SpawnMob = {
	spawn:Bool,
    ?positionX:Int,
    ?positionY:Int,
    ?entityType:EntityType,
}

class AiManager {

    private final mobsSpawnPoints = new Array<Point>();

    private var allowSpawnMobs = false;

    // Max mobs at a time
    private var mobsMax = 130;
    // Total mobs per level
    private var mobsTotal = 500;
    private var mobsSpawned = 0;
    private var mobsKilled = 0;

    private var mobsLastSpawnTime = 0.0;
    private var mobSpawnDelayMs = 2.500;

    private var secondsPassed = 0;

    public function new() {
        // mobsSpawnPoints.push(new Point(1900, 2500));
        // mobsSpawnPoints.push(new Point(1900, 3000));
        // mobsSpawnPoints.push(new Point(1900, 3500));

        // Top
        for (x in 0...26) {
            mobsSpawnPoints.push(new Point(200 * x, -200));
        }

        // Bottom
        for (x in 0...26) {
            mobsSpawnPoints.push(new Point(200 * x, 5200));
        }

        // Left
        for (y in 0...26) {
            mobsSpawnPoints.push(new Point(-200, 200 * y));
        }

        // Right
        for (y in 0...26) {
            mobsSpawnPoints.push(new Point(5200, 200 * y));
        }
    }

    public function secondPassed() {
        secondsPassed++;

        switch (secondsPassed) {
            case 13:
                mobSpawnDelayMs = 2.000;
            case 34:
                mobSpawnDelayMs = 1.500;
            case 55:
                mobSpawnDelayMs = 1.000;
            case 89:
                mobSpawnDelayMs = 0.500;
        }
    }

    public function spawnMob(playerX:Int, playerY:Int) {
        final result: SpawnMob = {
            spawn: false,
        };

        final now = haxe.Timer.stamp();

        if (allowSpawnMobs && mobsSpawned < mobsMax && (mobsLastSpawnTime == 0 || mobsLastSpawnTime + mobSpawnDelayMs < now)) {
            mobsSpawned++;
            mobsLastSpawnTime = now;

            // final mobSpawnPoint = mobsSpawnPoints[MathUtils.randomIntInRange(0, mobsSpawnPoints.length - 1)];

            final mobSpawnPoint = new Point(0, 0);
            final spawnDirection = MathUtils.randomIntInRange(1, 4);
            final leftOrRight = MathUtils.randomIntInRange(1, 2);
            final upOrDown = MathUtils.randomIntInRange(1, 2);

            switch (spawnDirection) {
                // спавн над игроком
                case 1:
                    if (leftOrRight == 1) {
                        mobSpawnPoint.x = playerX - MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenWidth / 2));
                    } else {
                        mobSpawnPoint.x = playerX + MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenWidth / 2));
                    }
                    mobSpawnPoint.y = playerY - Main.ActualScreenHeight;
                // спавн под игроком
                case 2:
                    if (leftOrRight == 1) {
                        mobSpawnPoint.x = playerX - MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenWidth / 2));
                    } else {
                        mobSpawnPoint.x = playerX + MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenWidth / 2));
                    }
                    mobSpawnPoint.y = playerY + Main.ActualScreenHeight;
                // спавн слева от игрока
                case 3:
                    mobSpawnPoint.x = playerX - Main.ActualScreenWidth;
                    if (upOrDown == 1) {
                        mobSpawnPoint.y = playerY - MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenHeight));
                    } else {
                        mobSpawnPoint.y = playerY + MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenHeight));
                    }
                // спавн справа от игрока
                case 4:
                    mobSpawnPoint.x = playerX + Main.ActualScreenWidth;
                    if (upOrDown == 1) {
                        mobSpawnPoint.y = playerY - MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenHeight));
                    } else {
                        mobSpawnPoint.y = playerY + MathUtils.randomIntInRange(1, Std.int(Main.ActualScreenHeight));
                    }
            }

            // TODO restrict spawn outside of the level borders

            result.spawn = true;
            result.entityType = MathUtils.randomIntInRange(1, 2) == 1 ? EntityType.ZOMBIE_BOY : EntityType.ZOMBIE_GIRL;
            result.positionX = Std.int(mobSpawnPoint.x);
            result.positionY = Std.int(mobSpawnPoint.y);
        }

        return result;
    }

    public function allowMobsSpawn(allowSpawnMobs:Bool) {
        this.allowSpawnMobs = allowSpawnMobs;
    }

    public function mobKilled() {
        // Update counters
        mobsKilled++;
        mobsSpawned--;
    }

    public function cleanAllMobs() {
        mobsSpawned = 0;
    }

    public function allMobsKilled() {
        return mobsKilled == mobsMax;
    }

    // Getters

    public function getMobsSpawnPoints() {
        return mobsSpawnPoints;
    }

    public function getMobsMax() {
        return mobsMax;
    }

    // Setters

    public function setMobsMax(mobsMax:Int) {
        this.mobsMax = mobsMax;
    }

}