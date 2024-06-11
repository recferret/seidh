package game.scene.home;

import game.event.EventManager;
import game.scene.base.BasicScene;
import hxd.res.DefaultFont;

class Friend extends h2d.Object {

    public function new(parent:h2d.Object, friendNameText:String, friendRewardText:String) {
        super(parent);

        final font : h2d.Font = DefaultFont.get();

        final friendName = new h2d.Text(font);
        friendName.text = friendNameText;
        friendName.textColor = GameConfig.FontColor;
        friendName.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendName.textAlign = Left;
        friendName.setScale(5);
        friendName.setPosition(25, 0);
        addChild(friendName);

        final friendReward = new h2d.Text(font);
        friendReward.text = "+" + friendRewardText + " SDH";
        friendReward.textColor = GameConfig.FontColor;
        friendReward.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendReward.textAlign = Right;
        friendReward.setScale(5);
        friendReward.setPosition(BasicScene.ActualScreenWidth - friendReward.textWidth / 2, 0);
        addChild(friendReward);
    }

}

class ScrollingFriendsContainer extends h2d.Object {

    private final friendItemHeight = 100;
    private var friendsTotal = 0;

    public function new(parent:h2d.Object) {
        super(parent);
    }

    public function addFriend(friendNameText:String, friendRewardText:String) {
        final newFriend = new Friend(this, friendNameText, friendRewardText);
        addChild(newFriend);
        newFriend.setPosition(0, friendsTotal * friendItemHeight);

        friendsTotal++;
    }

}

class InviteFriendButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object) {
        super(parent);

        bmp = new h2d.Bitmap(hxd.Res.ui.dialog.dialog_small.toTile(), this);
        h = bmp.tile.height;
        w = bmp.tile.width;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = 'Invite friend';
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(5);
        tf.setPosition(w / 2, (h - (tf.textHeight * 5)) / 2);

        addChild(tf);
    }

    public function getBitmap() {
        return bmp;
    }

    public function getHeight() {
        return h;
    }

    public function getWidth() {
        return w;
    }

}

class FriendsContent extends BasicHomeContent {

    public function new(scene:h2d.Scene) {
		super(scene);

        final font : h2d.Font = DefaultFont.get();

        final friendsInvited = new h2d.Text(font);
        friendsInvited.text = "Friends invited: 10";
        friendsInvited.textColor = GameConfig.FontColor;
        friendsInvited.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendsInvited.textAlign = Left;
        friendsInvited.setScale(3);
        friendsInvited.setPosition(25, 150);
        addChild(friendsInvited);

        final friendsOnline = new h2d.Text(font);
        friendsOnline.text = "Friends online: 2";
        friendsOnline.textColor = GameConfig.FontColor;
        friendsOnline.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendsOnline.textAlign = Left;
        friendsOnline.setScale(3);
        friendsOnline.setPosition(25, 200);
        addChild(friendsOnline);

        final totalRewards = new h2d.Text(font);
        totalRewards.text = "+20000 SDH";
        totalRewards.textColor = GameConfig.FontColor;
        totalRewards.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        totalRewards.textAlign = Right;
        totalRewards.setScale(3);
        totalRewards.setPosition(BasicScene.ActualScreenWidth - totalRewards.textWidth / 2, 150);
        addChild(totalRewards);

        // Invite button
        final inviteButton = new InviteFriendButton(this);
        inviteButton.setScale(0.6);
        inviteButton.setPosition(
            BasicScene.ActualScreenWidth / 2 - ((inviteButton.getWidth() / 2) * 0.6),
            290
        );

        final interactionInvite = new h2d.Interactive(inviteButton.getWidth(), inviteButton.getHeight(), inviteButton.getBitmap());
        interactionInvite.onPush = function(event : hxd.Event) {
            inviteButton.setScale(0.54);
        }
        interactionInvite.onRelease = function(event : hxd.Event) {
            inviteButton.setScale(0.6);
        }
        interactionInvite.onClick = function(event : hxd.Event) {
            EventManager.instance.notify(EventManager.EVENT_REF_SHARE, {});
        }

        // Friend scrolling container
        final friendsContainer = new ScrollingFriendsContainer(this);
        friendsContainer.setPosition(0, 450);

        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
        friendsContainer.addFriend("Sofia", "200");
    }

    public function update(dt:Float) {
    }
  
}