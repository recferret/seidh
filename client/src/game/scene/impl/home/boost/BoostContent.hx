package game.scene.impl.home.boost;

import game.event.EventManager;
import game.js.NativeWindowJS;
import game.ui.dialog.Dialog;
import game.ui.dialog.Dialog.DialogManager;
import game.ui.text.TextUtils;
import game.tilemap.TilemapManager;
import game.Player.BoostBody;
import game.Res.SeidhResource;

enum abstract BoostType(String) {
    var Boost; 
    var Rune;
    var Scroll;
    var Artifact;
}

enum abstract CurrencyType(String) {
    var Coins; 
    var Teeth;
    var Stars;
}

private class BoostCard extends h2d.Object {

    private final fui:h2d.Flow;

    public function new(parent:h2d.Object, px:Float, py:Float, verticalSpacing:Int, label:String, size:Int) {
        super(parent);

        setPosition(px, py);

        final bodyTile = Res.instance.getTileResource(SeidhResource.UI_BOOST_SCROLL_BODY);

        for (i in 0...size) {
            final bodyPart = new h2d.Bitmap(bodyTile, this);
            bodyPart.setPosition(0, 20 + (i * bodyTile.height));
        }

        new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_BOOST_SCROLL_HEADER), this);
        final footer = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_BOOST_SCROLL_HEADER), this);
        footer.tile.flipY();
        footer.setPosition(0, size * bodyTile.height - 20);

        final labelText = TextUtils.GetDefaultTextObject(0, 0, 4, Center, GameClientConfig.WhiteFontColor);
        labelText.text = label;
        labelText.setPosition(0, -42);
        addChild(labelText);

        fui = new h2d.Flow(this);
		fui.layout = Vertical;
		fui.verticalSpacing = verticalSpacing;
		fui.paddingHorizontal = -150;
		fui.paddingVertical = 145;
    }

    public function addBoost(boostItem:BoostItem) {
        fui.addChild(boostItem);
    }

}

private class BoostItem extends h2d.Object {

    public var currentBoostId = '';
    private var currentBoostName = '';
    private var currentBoostDescription1 = '';
    private var currentBoostDescription2 = null;

    public var nextBoostId = '';
    private var nextBoostName = '';
    private var nextBoostDescription1 = '';
    private var nextBoostDescription2 = null;

    private var boostPrice = null;
    private var currentLevel = 0;
    private var currencyType = CurrencyType.Coins;
    private var maxLevel = 3;

    private final nameText:h2d.Text;
    private final descriptionText:h2d.Text;
    private final priceText:h2d.Text;
    private final priceIcon:h2d.Bitmap;
    private final boostIcon:h2d.Bitmap;
    private var boostTile:h2d.Tile = null;

    private var clickStarted = false;
    
    public function new(parent:h2d.Object, root:h2d.Object, boost:BoostBody) {
        super(parent);

        parseBoost(boost);

        final iconBg = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.ICON_BOOST_BROWN), this);

        boostIcon = new h2d.Bitmap(this);
        priceIcon = new h2d.Bitmap(this);
        priceIcon.setScale(0.6);

        nameText = TextUtils.GetDefaultTextObject(iconBg.x + 80, iconBg.y - 55, 2, Left, GameClientConfig.WhiteFontColor);
        addChild(nameText);

        descriptionText = TextUtils.GetDefaultTextObject(iconBg.x + 78, iconBg.y - 15, 2, Left, GameClientConfig.DefaultFontColor);
        addChild(descriptionText);

        priceText = TextUtils.GetDefaultTextObject(iconBg.x + 80, iconBg.y + 25, 2, Left, GameClientConfig.DefaultFontColor);
        addChild(priceText);

        // Iteraction
        final interaction = new h2d.Interactive(450, iconBg.tile.height - 20);
        interaction.setPosition(iconBg.x - iconBg.tile.width / 2 + 20, iconBg.y - iconBg.tile.height / 2 + 10);
        interaction.onMove = function(event:hxd.Event) {
            clickStarted = false;
        }
        interaction.onPush = function(event:hxd.Event) {
            clickStarted = true;
            
            if (!DialogManager.IsDialogActive) {
                setScale(0.9);
            }
        }
        interaction.onRelease = function(event:hxd.Event) {
            if (!DialogManager.IsDialogActive) {
                setScale(1);
            }
        }
        interaction.onClick = function(event:hxd.Event) {
            if (clickStarted && !DialogManager.IsDialogActive) {
                BoostContent.BoostClick(
                    root,
                    currentBoostId,
                    nextBoostId,
                    nextBoostName,
                    nextBoostDescription1,
                    nextBoostDescription2,
                    boostPrice,
                    currencyType,
                    currentLevel,
                    maxLevel,
                );
            }
            clickStarted = false;
        }

        addChild(interaction);
        applyBoostData();
    }

    public function invalidate(boost:BoostBody) {
        parseBoost(boost);
        applyBoostData();
    }

    private function parseBoost(boost:BoostBody) {
        maxLevel = 3;

        if (boost.boostType == BoostType.Rune || boost.boostType == BoostType.Scroll) {
            if (!boost.levelOneAccquired) {
                currentBoostId = boost.levelOneId;
                currentBoostName = boost.levelZeroName;
                currentBoostDescription1 = '';
                currentBoostDescription2 = '';

                nextBoostId = boost.levelOneId;
                nextBoostName = boost.levelOneName;
                nextBoostDescription1 = boost.levelOneDescription1;
                nextBoostDescription2 = boost.levelOneDescription2;

                boostPrice = boost.levelOnePrice;
                
                currentLevel = 0;
                currencyType = boost.levelOneCurrencyType;
            } else {
                if (boost.levelThreeAccquired) {
                    currentBoostId = boost.levelThreeId;
                    currentBoostName = boost.levelThreeName;
                    currentBoostDescription1 = boost.levelThreeDescription1;
                    currentBoostDescription2 = boost.levelThreeDescription2;

                    nextBoostId = boost.levelThreeId;
                    nextBoostName = boost.levelThreeName;
                    nextBoostDescription1 = boost.levelThreeDescription1;
                    nextBoostDescription2 = boost.levelThreeDescription2;

                    currentLevel = 3;
                } else if (boost.levelTwoAccquired) {
                    currentBoostId = boost.levelTwoId;
                    currentBoostName = boost.levelTwoName;
                    currentBoostDescription1 = boost.levelTwoDescription1;
                    currentBoostDescription2 = boost.levelTwoDescription2;

                    nextBoostId = boost.levelThreeId;
                    nextBoostName = boost.levelThreeName;
                    nextBoostDescription1 = boost.levelThreeDescription1;
                    nextBoostDescription2 = boost.levelThreeDescription2;

                    boostPrice = boost.levelThreePrice;

                    currentLevel = 2;
                    currencyType = boost.levelThreeCurrencyType;
                } else {
                    currentBoostId = boost.levelOneId;
                    currentBoostName = boost.levelOneName;
                    currentBoostDescription1 = boost.levelOneDescription1;
                    currentBoostDescription2 = boost.levelOneDescription2;

                    nextBoostId = boost.levelTwoId;
                    nextBoostName = boost.levelTwoName;
                    nextBoostDescription1 = boost.levelTwoDescription1;
                    nextBoostDescription2 = boost.levelTwoDescription2;

                    boostPrice = boost.levelTwoPrice;

                    currentLevel = 1;
                    currencyType = boost.levelTwoCurrencyType;
                }
            }
        } else {
            currentBoostId = boost.levelOneId;
            currentBoostName = boost.levelOneName;
            currentBoostDescription1 = boost.levelOneDescription1;
            currentBoostDescription2 = boost.levelOneDescription2;

            boostPrice = boost.levelOnePrice;
            currencyType = boost.levelOneCurrencyType;
        }

        if (currentLevel == 0 && (boost.boostType == BoostType.Rune || boost.boostType == BoostType.Scroll)) {
            boostTile = h2d.Tile.fromColor(0x000000, 32, 32, 0);
        } else {
            switch (currentBoostId) {
                case BoostContent.TEETH:
                    boostTile = TilemapManager.instance.getTile(TileType.WEALTH_TEETH);
                case BoostContent.SALMON:
                    boostTile = TilemapManager.instance.getTile(TileType.SALMON);
                case BoostContent.SWORD:
                    boostTile = TilemapManager.instance.getTile(TileType.SWORD);
                
                case BoostContent.EXP_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.EXP_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_1_LVL_2);
                case BoostContent.EXP_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_1_LVL_3);
            
                case BoostContent.WEALTH_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.WEALTH_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_2_LVL_2);
                case BoostContent.WEALTH_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_3);
            
                case BoostContent.ATTACK_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.ATTACK_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2);
                case BoostContent.ATTACK_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_3);
            
                case BoostContent.MONSTERS_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.MONSTERS_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_4_LVL_2);
                case BoostContent.MONSTERS_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_4_LVL_3);
                
                case BoostContent.ITEMS_DROP_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.ITEMS_DROP_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_5_LVL_2);
                case BoostContent.ITEMS_DROP_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_5_LVL_3);
            
                case BoostContent.STATS_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.STATS_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_6_LVL_2);
                case BoostContent.STATS_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_6_LVL_3);
            
                case BoostContent.ARTIFACT_1:
                    boostTile = TilemapManager.instance.getTile(TileType.ARTIFACT_1);
                    maxLevel = 1;
            }
        }
    }

    private function applyBoostData() {
        nameText.text = currentBoostName;
        descriptionText.text = currentBoostDescription1;

        boostIcon.tile = boostTile;
        priceIcon.tile = currencyType == CurrencyType.Coins ?
            TilemapManager.instance.getTile(TileType.WEALTH_COINS) :
            TilemapManager.instance.getTile(TileType.WEALTH_TEETH);

        priceText.text = Std.string(boostPrice);
        priceIcon.setPosition(priceText.x + priceText.textWidth * 2 + 30, priceText.y + 16);

        if (currentLevel == 3) {
            priceText.alpha = 0;
            priceIcon.alpha = 0;
        } else {
            priceText.alpha = 1;
            priceIcon.alpha = 1;
        }
    }
}

class BoostContent extends BasicHomeContent implements EventListener {

    public static final TEETH = 'TEETH';
    public static final SALMON = 'SALMON';
    public static final SWORD = 'SWORD';

    public static final EXP_1 = 'EXP_1';
    public static final EXP_2 = 'EXP_2';
    public static final EXP_3 = 'EXP_3';

    public static final WEALTH_1 = 'WEALTH_1';
    public static final WEALTH_2 = 'WEALTH_2';
    public static final WEALTH_3 = 'WEALTH_3';

    public static final ATTACK_1 = 'ATTACK_1';
    public static final ATTACK_2 = 'ATTACK_2';
    public static final ATTACK_3 = 'ATTACK_3';

    public static final MONSTERS_1 = 'MONSTERS_1';
    public static final MONSTERS_2 = 'MONSTERS_2';
    public static final MONSTERS_3 = 'MONSTERS_3';
    
    public static final ITEMS_DROP_1 = 'ITEMS_DROP_1';
    public static final ITEMS_DROP_2 = 'ITEMS_DROP_2';
    public static final ITEMS_DROP_3 = 'ITEMS_DROP_3';

    public static final STATS_1 = 'STATS_1';
    public static final STATS_2 = 'STATS_2';
    public static final STATS_3 = 'STATS_3';

    public static final KNOWLEDGE_1 = 'KNOWLEDGE_1';
    public static final KNOWLEDGE_2 = 'KNOWLEDGE_2';
    public static final KNOWLEDGE_3 = 'KNOWLEDGE_3';

    public static final THOR_MIGHT_1 = 'THOR_MIGHT_1';
    public static final THOR_MIGHT_2 = 'THOR_MIGHT_2';
    public static final THOR_MIGHT_3 = 'THOR_MIGHT_3';

    public static final SKALD_SONG_1 = 'SKALD_SONG_1';
    public static final SKALD_SONG_2 = 'SKALD_SONG_2';
    public static final SKALD_SONG_3 = 'SKALD_SONG_3';

    public static final ARTIFACT_1 = 'ARTIFACT_1';

    final boostContainer: h2d.Object;

    public final boostsMap = new Map<String, BoostItem>();

    public function new() {
	    super(true);

        boostContainer = new h2d.Object(this);

        final boostCard = new BoostCard(boostContainer, Main.ActualScreenWidth / 2, 350, 50, 'CONSUMABLES', 12);
        final runesCard = new BoostCard(boostContainer, Main.ActualScreenWidth / 2, 1100, 45, 'RUNES', 20);
        final scrollsCard = new BoostCard(boostContainer, Main.ActualScreenWidth / 2, 2250, 50, 'SCROLLS', 12);
        final artifactsCard = new BoostCard(boostContainer, Main.ActualScreenWidth / 2, 3000, 50, 'ARTIFACTS', 6);

        for (boost in Player.instance.boosts) {
            var boostItem:BoostItem = null;

            switch (boost.boostType) {
                case BoostType.Boost:
                    boostItem = new BoostItem(boostCard, this, boost);
                    boostCard.addBoost(boostItem);
                case BoostType.Rune:
                    boostItem = new BoostItem(runesCard, this, boost);
                    runesCard.addBoost(boostItem);
                case BoostType.Scroll:
                    boostItem = new BoostItem(scrollsCard, this, boost);
                    scrollsCard.addBoost(boostItem);
                case BoostType.Artifact:
                    boostItem = new BoostItem(artifactsCard, this, boost);
                    artifactsCard.addBoost(boostItem);
            }

            if (boostItem != null) {
                boostsMap.set(boostItem.currentBoostId.split('_')[0], boostItem);
            }
        }

        EventManager.instance.subscribe(EventManager.EVENT_INVALIDATE_BOOSTS, this);
    }

	public function notify(event:String, message:Dynamic) {
		switch (event) {
			case EventManager.EVENT_INVALIDATE_BOOSTS:
				invalidateBoosts(message);
		}
	}

    public function update(dt:Float) {
        boostContainer.y = contentScrollY;
    }

    private function invalidateBoosts(message:Dynamic) {
        for (boost in Player.instance.boosts) {
            final boostObject = boostsMap.get(message.boostId);
            var validBoost = StringTools.contains(boost.levelOneId, message.boostId);
        
            if (boost.levelTwoId != null && StringTools.contains(boost.levelTwoId, message.boostId)) {
                validBoost = true;
            }
            if (boost.levelThreeId != null && StringTools.contains(boost.levelThreeId, message.boostId)) {
                validBoost = true;
            }

            if (validBoost) {
                boostObject.invalidate(boost);
            }
        }
    }

    public static function BoostClick(
        parent:h2d.Object,
        currentBoostId:String,
        nextBoostId:String,
        name:String,
        description1:String,
        description2:String,
        price:Int,
        currencyType:CurrencyType,
        currentLevel:Int, 
        maxLevel:Int
    ) {
        var hasEnoughMoney = true;
        var currencyTypeValue = 'coins';

        if (currencyType == CurrencyType.Coins) {
            if (Player.instance.coins - price < 0) {
                hasEnoughMoney = false;
            }
        } else if (currencyType == CurrencyType.Teeth) {
            currencyTypeValue = 'teeth';
            if (Player.instance.teeth - price < 0) {
                hasEnoughMoney = false;
            }
        }

        function positiveCallback1():Void {
            NativeWindowJS.networkBuyBoost(nextBoostId, function callback(data:Dynamic) {
                if (data.success) {
                    Player.instance.setBoostData(data.boosts);
                    EventManager.instance.notify(EventManager.EVENT_INVALIDATE_BOOSTS, { boostId: currentBoostId.split('_')[0] });
                } else {
                    // TODO impl alert
                }
            });
        }

        DialogManager.ShowDialog(
			parent, 
			DialogType.MEDIUM, 
			{ label: name, scale: 4, color: GameClientConfig.WhiteFontColor, },
			{ label: description1, scale: 3, color: GameClientConfig.DefaultFontColor, },
            description2 != null ? { label: description2, scale: 3, color: GameClientConfig.DefaultFontColor, } : null,
			currentLevel < 3 ? 
                { 
                    label: hasEnoughMoney ? 
                        'Buy it for ' + price + ' ' + currencyTypeValue + ' ?' : 
                        'Not enough ' + currencyTypeValue + '!', 
                    scale: hasEnoughMoney ? 3 : 4, 
                    color: hasEnoughMoney ? GameClientConfig.WhiteFontColor : GameClientConfig.ErrorFontColor, 
                } : null,
            {
                buttons: (hasEnoughMoney && currentLevel < 3) ? TWO : ONE,
                positiveLabel: (hasEnoughMoney && currentLevel < 3) ? "YES" : "OK",
                negativeLabel: "NO",
                positiveCallback: positiveCallback1,
                negativeCallback: null,
            },
		);
    }

}