package game.scene.home;

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

class JoinButton extends h2d.Object {
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
        tf.text = 'Join game';
        tf.textColor = GameConfig.FontColor;
        tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        tf.textAlign = Center;
        tf.setScale(5);
        tf.setPosition(w / 2, (h - (tf.textHeight * 5)) / 2);

        addChild(tf);

        setPosition(25, 70);
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
                height = 200;
        }

        final font : h2d.Font = DefaultFont.get();

        final friendName = new h2d.Text(font);
        friendName.text = friendNameText + statusText;
        friendName.textColor = GameConfig.FontColor;
        friendName.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendName.textAlign = Left;
        friendName.setScale(4);
        friendName.setPosition(25, 0);
        addChild(friendName);

        final friendReward = new h2d.Text(font);
        friendReward.text = "+" + friendRewardText + " SDH";
        friendReward.textColor = GameConfig.FontColor;
        friendReward.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendReward.textAlign = Right;
        friendReward.setScale(4);
        friendReward.setPosition(BasicScene.ActualScreenWidth - friendReward.textWidth / 2, 0);
        addChild(friendReward);

        if (friendStatus == PLAYING_POSSIBLE_TO_JOIN) {
            final joinGameButton = new JoinButton(this);
            joinGameButton.setScale(0.4);

            final interactionJoin = new h2d.Interactive(joinGameButton.getWidth(), joinGameButton.getHeight(), joinGameButton.getBitmap());
            interactionJoin.onPush = function(event : hxd.Event) {
                joinGameButton.setScale(0.36);
            }
            interactionJoin.onRelease = function(event : hxd.Event) {
                joinGameButton.setScale(0.4);
            }
            interactionJoin.onClick = function(event : hxd.Event) {
                SoundManager.instance.playButton2();
            }
        }
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
            SoundManager.instance.playButton2();
            EventManager.instance.notify(EventManager.EVENT_REF_SHARE, {});
        }

        // Friend scrolling container
        final friendsContainer = new ScrollingFriendsContainer(this);
        friendsContainer.setPosition(0, 450);

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