package game.ui.debug;

#if debug
import haxe.ui.containers.VBox;
#end

import engine.base.EngineConfig;
import engine.base.types.TypesBaseEntity;
import engine.seidh.entity.CharacterEntityConfig;

import game.GameClientConfig;
import game.event.EventManager;

#if debug
@:build(haxe.ui.ComponentBuilder.build("assets/character-and-zombie-balance-view.xml"))
class CharacterAndZombieBalanceView extends VBox {
    public function new() {
        super();

        spawnZombieButton.onClick = function(e) {
            EventManager.instance.notify(EventManager.EVENT_SPAWN_CHARACTER, {
                entityType: EntityType.ZOMBIE_BOY,
            });
        };
    }
    
    public function update() {
        // Movement
        final movSpeed = Std.int(movementSpeedSlider.pos);
        movementSpeedLabel.htmlText = 'Movement speed: ' + movSpeed + '/' + movementSpeedSlider.max;
        GameClientConfig.instance.CharacterMovementSpeed = movSpeed;

        final movDelay = movementInputDelaySlider.pos;
        movementInputDelayLabel.htmlText = 'Movement input delay: ' + movDelay + '/' + movementInputDelaySlider.max;
        GameClientConfig.instance.CharacterMovementInputDelay = movDelay;
    
        // Action main
        final actionMainWidth = Std.int(actionMainWidthSlider.pos);
        actionMainWidthLabel.htmlText = 'Action main width: ' + actionMainWidth + '/' + actionMainWidthSlider.max;
        GameClientConfig.instance.CharacterActionMainWidth = actionMainWidth;

        final actionMainHeight = Std.int(actionMainHeightSlider.pos);
        actionMainHeightLabel.htmlText = 'Action main height: ' + actionMainHeight + '/' + actionMainHeightSlider.max;
        GameClientConfig.instance.CharacterActionMainHeight = actionMainHeight;

        final actionMainOffsetX = Std.int(actionMainOffsetXSlider.pos);
        actionMainOffsetXLabel.htmlText = 'Action main offset X: ' + actionMainOffsetX + '/' + actionMainOffsetXSlider.max;
        GameClientConfig.instance.CharacterActionMainOffsetX = actionMainOffsetX;

        final actionMainOffsetY = Std.int(actionMainOffsetYSlider.pos);
        actionMainOffsetYLabel.htmlText = 'Action main offset Y: ' + actionMainOffsetY + '/' + actionMainOffsetYSlider.max;
        GameClientConfig.instance.CharacterActionMainOffsetY = actionMainOffsetY;

        final actionMainDelay = actionMainInputDelaySlider.pos;
        actionMainInputDelayLabel.htmlText = 'Action main input delay: ' + actionMainDelay + '/' + actionMainInputDelaySlider.max;
        GameClientConfig.instance.CharacterActionMainInputDelay = actionMainDelay;

        final actionMainDamage = Std.int(actionMainDamageSlider.pos);
        actionMainDamageLabel.htmlText = 'Action main damage: ' + actionMainDamage + '/' + actionMainDamageSlider.max;
        GameClientConfig.instance.CharacterActionMainDamage = actionMainDamage;

        // AI
        EngineConfig.AI_ENABLED = aiEnabledCheckbox.selected;
        EngineConfig.AI_MOVEMENT_ENABLED = aiMovementCheckbox.selected;
        EngineConfig.AI_ACTION_ENABLED = aiActionCheckbox.selected;

        EngineConfig.MONSTERS_SPAWN_ENABLED = zombieSpawnCheckbox.selected;

        final maxZombies = Std.int(zombiesMaxSlider.pos);
        zombiesMaxLabel.htmlText = 'Max zombies: ' + maxZombies + '/' + zombiesMaxSlider.max;
        EngineConfig.MONSTERS_MAX = maxZombies;

        final zombiesSpawnDelay = zombiesSpawnDelaySlider.pos;
        zombiesSpawnDelayLabel.htmlText = 'Zombies spawn delay: ' + zombiesSpawnDelay + '/' + zombiesSpawnDelaySlider.max;
        EngineConfig.MONSTERS_SPAWN_DELAY = zombiesSpawnDelay;

        final zombieHealth = Std.int(zombieHealthSlider.pos);
        zombieHealthLabel.htmlText = 'Zombie health: ' + zombieHealth + '/' + zombieHealthSlider.max;
        CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.health = zombieHealth;
        CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.health = zombieHealth;

        final zombieSpeed = Std.int(zombieSpeedSlider.pos);
        zombieSpeedLabel.htmlText = 'Zombie speed: ' + zombieSpeed + '/' + zombieSpeedSlider.max;
        CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.movement.runSpeed = zombieSpeed;
        CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.movement.runSpeed = zombieSpeed;

        final zombieDamage = Std.int(zombieDamageSlider.pos);
        zombieDamageLabel.htmlText = 'Zombie damage: ' + zombieDamage + '/' + zombieDamageSlider.max;
        CharacterEntityConfig.CHARACTERS_CONFIG.zombieBoy.actionMain.damage = zombieDamage;
        CharacterEntityConfig.CHARACTERS_CONFIG.zombieGirl.actionMain.damage = zombieDamage;
    }
}
#end