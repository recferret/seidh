package game.scene.home;

import game.js.NativeWindowJS;
import game.Res.SeidhResource;
import game.sound.SoundManager;
import game.event.EventManager;
import game.scene.base.BasicScene;
import hxd.res.DefaultFont;

enum abstract FriendStatus(Int) {
	var OFFLINE = 1;
	var ONLINE = 2;
    var PLAYING_POSSIBLE_TO_JOIN = 3;
    var PLAYING_NOT_POSSIBLE_TO_JOIN = 4;
}

class Friend extends h2d.Object {

    private var height = 100;

    public function new(parent:h2d.Object, friendStatus:FriendStatus, friendNameText:String, friendRewardText:String) {
        super(parent);

        var statusText = '';
        switch (friendStatus) {
            case OFFLINE:
                statusText = ', offline';
            case ONLINE:
                statusText = ', online';
            case PLAYING_NOT_POSSIBLE_TO_JOIN:
                statusText = ', playing';
            case PLAYING_POSSIBLE_TO_JOIN:
                statusText = ', playing';
                // height = 200;
        }

        final font : h2d.Font = DefaultFont.get();

        final friendName = new h2d.Text(font);
        friendName.text = friendNameText + statusText;
        friendName.textColor = GameConfig.FontColor;
        friendName.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendName.textAlign = Left;
        friendName.setScale(4);
        friendName.setPosition(65, 0);
        addChild(friendName);

        final friendReward = new h2d.Text(font);
        friendReward.text = "+" + friendRewardText + " SDH";
        friendReward.textColor = GameConfig.FontColor;
        friendReward.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendReward.textAlign = Right;
        friendReward.setScale(4);
        friendReward.setPosition(Main.ActualScreenWidth - friendReward.textWidth - 15, 0);
        addChild(friendReward);
    }

    public function getHeight() {
        return height;
    }

}

class ScrollingFriendsContainer extends h2d.Object {

    private var friendsTotal = 0;
    private var friendNextPositionY = 0;

    public function new(parent:h2d.Object) {
        super(parent);
    }

    public function addFriend(friendNameText:String, friendStatus:FriendStatus, friendRewardText:String) {
        final newFriend = new Friend(this, friendStatus, friendNameText, friendRewardText);
        addChild(newFriend);
        newFriend.setPosition(0, friendNextPositionY);
        friendNextPositionY  += newFriend.getHeight();
        // friendsTotal++;
    }

}

class InviteFriendButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object) {
        super(parent);

        final scaleX = 1.6;
        final scaleY = 0.5;
        bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_DIALOG_WINDOW_SMALL), this);
        bmp.scaleX = scaleX;
        bmp.scaleY = scaleY;
        w = bmp.tile.width * scaleX;
        h = bmp.tile.height * scaleY;

        final font : h2d.Font = DefaultFont.get();
        final tf = new h2d.Text(font);
        tf.text = 'Invite Friend';
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(4);
        tf.setPosition(0, -35);

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

    public function new() {
		super();

        final font : h2d.Font = DefaultFont.get();

        final friendsInvited = new h2d.Text(font);
        friendsInvited.text = "Friends invited: 10";
        friendsInvited.textColor = GameConfig.FontColor;
        friendsInvited.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendsInvited.textAlign = Left;
        friendsInvited.setScale(3);
        friendsInvited.setPosition(65, 400);
        addChild(friendsInvited);

        final friendsOnline = new h2d.Text(font);
        friendsOnline.text = "Friends online: 2";
        friendsOnline.textColor = GameConfig.FontColor;
        friendsOnline.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendsOnline.textAlign = Left;
        friendsOnline.setScale(3);
        friendsOnline.setPosition(65, 450);
        addChild(friendsOnline);

        final totalRewards = new h2d.Text(font);
        totalRewards.text = "+20000 SDH";
        totalRewards.textColor = GameConfig.FontColor;
        totalRewards.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        totalRewards.textAlign = Right;
        totalRewards.setScale(3);
        totalRewards.setPosition(Main.ActualScreenWidth - totalRewards.textWidth, 400);
        addChild(totalRewards);

        // Invite button
        final inviteButton = new InviteFriendButton(this);
        inviteButton.setPosition(
            Main.ActualScreenWidth / 2,
            300
        );

        final interactionInvite = new h2d.Interactive(inviteButton.getWidth(), inviteButton.getHeight());
        interactionInvite.setPosition(
            Main.ActualScreenWidth / 2 - inviteButton.getWidth() / 2,
            300 - inviteButton.getHeight() / 2
        );
        interactionInvite.onPush = function(event : hxd.Event) {
            inviteButton.setScale(0.9);
        }
        interactionInvite.onRelease = function(event : hxd.Event) {
            inviteButton.setScale(1);
        }
        interactionInvite.onClick = function(event : hxd.Event) {
            SoundManager.instance.playButton2();
            NativeWindowJS.trackInviteFriendClick();
            EventManager.instance.notify(EventManager.EVENT_REF_SHARE, {});
        }
        addChild(interactionInvite);

        // Friend scrolling container
        final friendsContainer = new ScrollingFriendsContainer(this);
        friendsContainer.setPosition(0, 600);

        friendsContainer.addFriend("Sofia", FriendStatus.PLAYING_POSSIBLE_TO_JOIN, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.PLAYING_NOT_POSSIBLE_TO_JOIN, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.ONLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
    }

    public function update(dt:Float) {
    }
  
}