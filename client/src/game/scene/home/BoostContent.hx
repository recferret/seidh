package game.scene.home;

import h2d.Object;
import game.tilemap.TilemapManager;
import game.Player.BoostBody;
import game.Res.SeidhResource;

import hxd.res.DefaultFont;

class BoostItem extends h2d.Object {

    public function new(parent:h2d.Object, px:Int, py:Int, boost:BoostBody) {
        super(parent);

        setPosition(px, py);

        final iconBg = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.ICON_BOOST), this);
        var boostIcon:h2d.Bitmap = null;

        var boostId = null;
        var boostDescription = null;
        var boostPrice = null;
        if (!boost.levelOneAccquired) {
            boostId = boost.levelOneId;
            boostDescription = boost.levelOneDescription;
            boostPrice = boost.levelOnePrice;
        } else if (!boost.levelTwoAccquired) {
            boostId = boost.levelTwoId;
            boostDescription = boost.levelTwoDescription;
            boostPrice = boost.levelTwoPrice;
        } else if (!boost.levelThreeAccquired) {
            boostId = boost.levelThreeId;
            boostDescription = boost.levelThreeDescription;
            boostPrice = boost.levelThreePrice;
        }

        switch (boostId) {
            case BoostContent.EXP_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1), this);
            case BoostContent.EXP_2:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_1_LVL_2), this);
            case BoostContent.EXP_3:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_1_LVL_3), this);
        
            case BoostContent.ITEM_RADIUS_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1), this);
            case BoostContent.ITEM_RADIUS_2:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_2_LVL_2), this);
            case BoostContent.ITEM_RADIUS_3:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2), this);
        
            case BoostContent.MORE_TOKENS_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1), this);
            case BoostContent.MORE_TOKENS_2:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2), this);
            case BoostContent.MORE_TOKENS_3:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_3_LVL_2), this);
        
            case BoostContent.MONSTERS_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_ANY_LVL_1), this);
            case BoostContent.MONSTERS_2:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_4_LVL_2), this);
            case BoostContent.MONSTERS_3:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.RUNE_TYPE_4_LVL_2), this);
            
            case BoostContent.ITEMS_DROP_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SCROLL_TYPE_ANY_LVL_1), this);
            case BoostContent.ITEMS_DROP_2:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SCROLL_TYPE_1_LVL_2), this);
            case BoostContent.ITEMS_DROP_3:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SCROLL_TYPE_1_LVL_3), this);
        
            case BoostContent.STATS_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SCROLL_TYPE_ANY_LVL_1), this);
            case BoostContent.STATS_2:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SCROLL_TYPE_2_LVL_2), this);
            case BoostContent.STATS_3:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.SCROLL_TYPE_2_LVL_3), this);
        
            case BoostContent.ARTIFACT_1:
                boostIcon = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.ARTIFACT_1), this);
        }

        boostIcon.setPosition(iconBg.x + 10, iconBg.y + 10);

        final font : h2d.Font = DefaultFont.get();
        final descriptionText = new h2d.Text(font);
        descriptionText.text = boostDescription;
        descriptionText.textColor = GameConfig.FontColor;
        descriptionText.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        descriptionText.textAlign = Left;
        descriptionText.setScale(2);
        descriptionText.setPosition(iconBg.x + 80, iconBg.y - 55);
        addChild(descriptionText);

        final priceText = new h2d.Text(font);
        priceText.text = Std.string(boostPrice);
        priceText.textColor = GameConfig.FontColor;
        priceText.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        priceText.textAlign = Left;
        priceText.setScale(2);
        priceText.setPosition(iconBg.x + 80, iconBg.y + 25);
        addChild(priceText);

        final coin = new h2d.Bitmap(TilemapManager.instance.getTile(TileType.COIN), this);
        coin.setScale(0.6);
        coin.setPosition(priceText.x + priceText.textWidth + 40, priceText.y + 5);

        // Iteraction

        final interaction = new h2d.Interactive(300, boostIcon.height);
        interaction.setPosition(boostIcon.x - boostIcon.tile.width / 2, boostIcon.y - boostIcon.tile.height / 2);

        

        interaction.onPush = function(event : hxd.Event) {
            setScale(0.9);
        }
        interaction.onRelease = function(event : hxd.Event) {
            setScale(1);
        }
        interaction.onClick = function(event : hxd.Event) {
        }
        addChild(interaction);
    }

}

class BoostFrame extends h2d.Object {

    public function new(parent:h2d.Object) {
        super(parent);

        final header = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_XL_HEADER));
        final footer = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_XL_FOOTER));

        final basicHeightDiff = Main.ActualScreenHeight - 1280;
        final middlePartHeight = Main.ActualScreenHeight - Std.int(header.tile.height) - Std.int(footer.tile.height) - basicHeightDiff;
        final middle = new h2d.Bitmap(h2d.Tile.fromColor(GameConfig.UiBrownColor, Std.int(header.tile.width) + 1, middlePartHeight + 100));

        header.setPosition(Main.ActualScreenWidth / 2, header.tile.height - 100);
        footer.setPosition(Main.ActualScreenWidth / 2, Main.ActualScreenHeight - footer.tile.height);
        middle.setPosition(113, header.tile.height + 45);

        addChild(header);
        addChild(middle);
        addChild(footer);
    }

    public function update(dt:Float) {
        // rune1.y++;
    }
}

class BoostContent extends BasicHomeContent {

    public static final EXP_1 = 'EXP_1';
    public static final EXP_2 = 'EXP_2';
    public static final EXP_3 = 'EXP_3';

    public static final ITEM_RADIUS_1 = 'ITEM_RADIUS_1';
    public static final ITEM_RADIUS_2 = 'ITEM_RADIUS_2';
    public static final ITEM_RADIUS_3 = 'ITEM_RADIUS_3';

    public static final MORE_TOKENS_1 = 'MORE_TOKENS_1';
    public static final MORE_TOKENS_2 = 'MORE_TOKENS_2';
    public static final MORE_TOKENS_3 = 'MORE_TOKENS_3';

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

    final boostFrame: BoostFrame;
    final boostContainer: h2d.Object;

    public function new() {
	    super();

        boostFrame = new BoostFrame(this);
        boostContainer = new h2d.Object(this);

        var boostX = 180;
        var boostY = 320;
        for (boost in Player.instance.boosts) {
            new BoostItem(boostContainer, boostX, boostY, boost);
            boostY += 150;
        }
    }

    public function update(dt:Float) {
        // boostFrame.update(dt);

        // boostContainer.y = contentScrollY;
    }

    public static function BoostClick(boost:BoostBody) {
        // if (boost.) {
        //     trace('Already accquired');
        // } else {
        //     trace('Check for balance locally');
        // }

        trace('boost click');

        // TODO show the dialog
    }

}