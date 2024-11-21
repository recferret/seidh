package game.scene.impl.home.boost;

import game.ui.text.TextUtils;
import game.event.EventManager;
import game.js.NativeWindowJS;
import game.ui.dialog.Dialog;
import game.ui.dialog.Dialog.DialogManager;
import game.tilemap.TilemapManager;
import game.Player.BoostBody;

class BoostItem extends h2d.Object {

    public var currentBoostId = '';
    private var currentBoostName = '';
    private var currentBoostDescription = '';

    public var nextBoostId = '';
    private var nextBoostName = '';
    private var nextBoostDescription = '';

    private var boostPrice = null;
    private var currentLevel = 0;
    private var currencyType = BoostContent.CURRENCY_TYPE_COINS;
    private var maxLevel = 3;

    private final nameText:h2d.Text;
    private final descriptionText:h2d.Text;
    private final priceText:h2d.Text;
    private final priceIcon:h2d.Bitmap;
    private final boostIcon:h2d.Bitmap;
    private var boostTile:h2d.Tile = null;
    
    public function new(parent:h2d.Object, px:Int, py:Int, boost:BoostBody) {
        super(parent);

        setPosition(px, py);
        parseBoost(boost);

        final iconBg = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.ICON_BOOST), this);
        boostIcon = new h2d.Bitmap(this);
        boostIcon.tile = boostTile;
        boostIcon.setPosition(iconBg.x + 10, iconBg.y + 10);

        nameText = TextUtils.GetDefaultTextObject(iconBg.x + 80, iconBg.y - 55, 2, Left, GameConfig.WhiteFontColor);
        addChild(nameText);

        descriptionText = TextUtils.GetDefaultTextObject(iconBg.x + 78, iconBg.y - 15, 2, Left, GameConfig.DefaultFontColor);
        addChild(descriptionText);

        priceText = TextUtils.GetDefaultTextObject(iconBg.x + 80, iconBg.y + 25, 2, Left, GameConfig.DefaultFontColor);
        addChild(priceText);

        priceIcon = new h2d.Bitmap(
            currencyType == BoostContent.CURRENCY_TYPE_COINS ?
                TilemapManager.instance.getTile(TileType.WEALTH_COINS) :
                TilemapManager.instance.getTile(TileType.WEALTH_TEETH), this);
        priceIcon.setScale(0.6);

        descriptionText.text = currentBoostDescription;

        nameText.text = currentBoostName;
        priceText.text = Std.string(boostPrice);
        priceIcon.setPosition(priceText.x + priceText.textWidth * 2 + 30, priceText.y + 10);

        // Iteraction
        final interaction = new h2d.Interactive(550, boostIcon.height);
        interaction.setPosition(boostIcon.x - boostIcon.tile.width / 2, boostIcon.y - boostIcon.tile.height / 2);

        interaction.onPush = function(event:hxd.Event) {
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
            if (!DialogManager.IsDialogActive) {
                BoostContent.BoostClick(parent, nextBoostId, nextBoostName, nextBoostDescription, boostPrice, currencyType, currentLevel, maxLevel);
            }
        }
        addChild(interaction);
    }

    private function parseBoost(boost:BoostBody) {
        maxLevel = 3;

        if (!boost.levelOneAccquired) {
            currentBoostId = boost.levelOneId;
            currentBoostName = boost.levelZeroName;
            currentBoostDescription = '';

            nextBoostId = boost.levelOneName;
            nextBoostName = boost.levelOneName;
            nextBoostDescription = boost.levelOneDescription;

            boostPrice = boost.levelOnePrice;
            
            currentLevel = 0;
            currencyType = boost.levelOneCurrencyType;
        } else {
            if (boost.levelThreeAccquired) {
                currentLevel = 3;
            } else if (boost.levelTwoAccquired) {
                currentBoostId = boost.levelTwoId;
                currentBoostName = boost.levelTwoName;
                currentBoostDescription = boost.levelTwoDescription;

                nextBoostId = boost.levelThreeId;
                nextBoostName = boost.levelThreeName;
                nextBoostDescription = boost.levelThreeDescription;

                boostPrice = boost.levelThreePrice;

                currentLevel = 2;
                currencyType = boost.levelThreeCurrencyType;
            } else {
                currentBoostId = boost.levelOneId;
                currentBoostName = boost.levelOneName;
                currentBoostDescription = boost.levelOneDescription;

                nextBoostId = boost.levelTwoId;
                nextBoostName = boost.levelTwoName;
                nextBoostDescription = boost.levelTwoDescription;

                boostPrice = boost.levelTwoPrice;

                currentLevel = 1;
                currencyType = boost.levelTwoCurrencyType;
            }
        }

        if (currentLevel == 0) {
            boostTile = h2d.Tile.fromColor(0x000000, 32, 32, 0);
        } else {
            switch (currentBoostId) {
                case BoostContent.EXP_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.EXP_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_1_LVL_2);
                case BoostContent.EXP_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_1_LVL_3);
            
                case BoostContent.ITEM_RADIUS_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.ITEM_RADIUS_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_2_LVL_2);
                case BoostContent.ITEM_RADIUS_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2);
            
                case BoostContent.MORE_COINS_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.MORE_COINS_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2);
                case BoostContent.MORE_COINS_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2);
            
                case BoostContent.MONSTERS_1:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1);
                case BoostContent.MONSTERS_2:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_4_LVL_2);
                case BoostContent.MONSTERS_3:
                    boostTile = TilemapManager.instance.getTile(TileType.RUNE_TYPE_4_LVL_2);
                
                case BoostContent.ITEMS_DROP_1:
                    boostTile = TilemapManager.instance.getTile(TileType.SCROLL_TYPE_ANY_LVL_1);
                case BoostContent.ITEMS_DROP_2:
                    boostTile = TilemapManager.instance.getTile(TileType.SCROLL_TYPE_1_LVL_2);
                case BoostContent.ITEMS_DROP_3:
                    boostTile = TilemapManager.instance.getTile(TileType.SCROLL_TYPE_1_LVL_3);
            
                case BoostContent.STATS_1:
                    boostTile = TilemapManager.instance.getTile(TileType.SCROLL_TYPE_ANY_LVL_1);
                case BoostContent.STATS_2:
                    boostTile = TilemapManager.instance.getTile(TileType.SCROLL_TYPE_2_LVL_2);
                case BoostContent.STATS_3:
                    boostTile = TilemapManager.instance.getTile(TileType.SCROLL_TYPE_2_LVL_3);
            
                case BoostContent.ARTIFACT_1:
                    boostTile = TilemapManager.instance.getTile(TileType.ARTIFACT_1);
                    maxLevel = 1;
            }
        }
    }

    public function invalidate(boost:BoostBody) {
        parseBoost(boost);
    }
}

class BoostContent extends BasicHomeContent implements EventListener {

    public static final EXP_1 = 'EXP_1';
    public static final EXP_2 = 'EXP_2';
    public static final EXP_3 = 'EXP_3';

    public static final ITEM_RADIUS_1 = 'ITEM_RADIUS_1';
    public static final ITEM_RADIUS_2 = 'ITEM_RADIUS_2';
    public static final ITEM_RADIUS_3 = 'ITEM_RADIUS_3';

    public static final MORE_COINS_1 = 'MORE_COINS_1';
    public static final MORE_COINS_2 = 'MORE_COINS_2';
    public static final MORE_COINS_3 = 'MORE_COINS_3';

    public static final MONSTERS_1 = 'MONSTERS_1';
    public static final MONSTERS_2 = 'MONSTERS_2';
    public static final MONSTERS_3 = 'MONSTERS_3';
    
    public static final ITEMS_DROP_1 = 'ITEMS_DROP_1';
    public static final ITEMS_DROP_2 = 'ITEMS_DROP_2';
    public static final ITEMS_DROP_3 = 'ITEMS_DROP_3';

    public static final STATS_1 = 'STATS_1';
    public static final STATS_2 = 'STATS_2';
    public static final STATS_3 = 'STATS_3';

    public static final ARTIFACT_1 = 'ARTIFACT_1';

    public static final CURRENCY_TYPE_COINS = 'Coins';
    public static final CURRENCY_TYPE_TEETH = 'Teeth';

    final boostContainer: h2d.Object;

    public final boostsMap = new Map<String, BoostItem>();

    public function new() {
	    super(true);

        boostContainer = new h2d.Object(this);

        var boostX = 180;
        var boostY = 360;

        for (boost in Player.instance.boosts) {
            final boost = new BoostItem(boostContainer, boostX, boostY, boost);
            boostsMap.set(boost.currentBoostId, boost);
            boostY += 150;
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
        // boostFrame.update(dt);

        // boostContainer.y = contentScrollY;
    }

    private function invalidateBoosts(message:Dynamic) {
        for (boost in Player.instance.boosts) {
            if (boost.levelOneId == message.accquiredBoostId || 
                boost.levelTwoId == message.accquiredBoostId ||
                boost.levelThreeId == message.accquiredBoostId) {
                boostsMap.get(message.accquiredBoostId).invalidate(boost);
            }
        }
    }

    public static function BoostClick(
        parent:h2d.Object,
        boostId:String,
        name:String, 
        description:String, 
        price:Int, 
        currencyType:String,
        currentLevel:Int, 
        maxLevel:Int
    ) {
        var hasEnoughMoney = true;

        if (currencyType == BoostContent.CURRENCY_TYPE_COINS) {
            if (Player.instance.coins - price < 0) {
                hasEnoughMoney = false;
            }
        } else {
            if (Player.instance.teeth - price < 0) {
                hasEnoughMoney = false;
            }
        }

        DialogManager.ShowDialog(
			parent, 
			DialogType.MEDIUM, 
			{ label: name, scale: 4, color: GameConfig.WhiteFontColor, },
			{ label: description, scale: 3, color: GameConfig.DefaultFontColor, },
			{ 
                label: hasEnoughMoney ? 
                    'Buy it for ' + price + ' ' + currencyType.toLowerCase() + ' ?' : 
                    'Not enough teeth!', 
                scale: hasEnoughMoney ? 3 : 4, 
                color: hasEnoughMoney ? GameConfig.DefaultFontColor : GameConfig.ErrorFontColor, 
            },
            {
                buttons: hasEnoughMoney ? TWO : ONE,
                positiveLabel: hasEnoughMoney ? "YES" : "OK",
                negativeLabel: "NO",
                positiveCallback: function positiveCallback() {
                    NativeWindowJS.networkBuyBoost(boostId, function callback(data:Dynamic) {
                        if (data.success) {
                            Player.instance.setBoostData(data.boosts);
                            EventManager.instance.notify(EventManager.EVENT_INVALIDATE_BOOSTS, { accquiredBoostId: boostId });
                        } else {
                            // TODO impl alert
                        }
                    });
                },
                negativeCallback: null,
            },
		);
    }
}