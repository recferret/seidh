package game.scene.impl.home.friends;

import game.ui.text.TextUtils;
import game.js.NativeWindowJS;
import game.Res.SeidhResource;
import game.sound.SoundManager;
import game.event.EventManager;
import hxd.res.DefaultFont;

enum abstract FriendStatus(Int) {
	var OFFLINE = 1;
	var ONLINE = 2;
    var PLAYING_POSSIBLE_TO_JOIN = 3;
    var PLAYING_NOT_POSSIBLE_TO_JOIN = 4;
}

class Friend extends h2d.Object {

    private var height = 50;

    public function new(parent:h2d.Object, friendStatus:FriendStatus, friendNameText:String, friendRewardText:String) {
        super(parent);

        var statusText = '';
        // switch (friendStatus) {
        //     case OFFLINE:
        //         statusText = ', offline';
        //     case ONLINE:
        //         statusText = ', online';
        //     case PLAYING_NOT_POSSIBLE_TO_JOIN:
        //         statusText = ', playing';
        //     case PLAYING_POSSIBLE_TO_JOIN:
        //         statusText = ', playing';
        // }

        final lvl = ', 1 LVL';

        final font : h2d.Font = DefaultFont.get();

        final friendDetails = TextUtils.GetDefaultTextObject(65, 0, 3.5, Left, GameConfig.DefaultFontColor);
        friendDetails.text = friendNameText + statusText + lvl;
        addChild(friendDetails);
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
        newFriend.setPosition(60, friendNextPositionY);
        friendNextPositionY += newFriend.getHeight();
        // friendsTotal++;
    }

}

class InviteFriendButton extends h2d.Object {

    private final w = 0.0;
    private final h = 0.0;
    private final bmp:h2d.Bitmap;

    public function new(parent:h2d.Object) {
        super(parent);

        bmp = new h2d.Bitmap(Res.instance.getTileResource(SeidhResource.UI_HOME_LVL_YAY), this);

        w = bmp.tile.width;
        h = bmp.tile.height;

        // final font : h2d.Font = DefaultFont.get();
        // final tf = new h2d.Text(font);
        // tf.text = 'Invite Friend';
        // tf.textColor = GameConfig.FontColor;
        // tf.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        // tf.textAlign = Center;
        // tf.setScale(4);
        // tf.setPosition(0, -35);
        // addChild(tf);
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
		super(true);

        final friendsInvited = TextUtils.GetDefaultTextObject(125, 450, 3, Left, GameConfig.DefaultFontColor);
        friendsInvited.text = "Friends invited: 10";
        addChild(friendsInvited);

        final friendsOnline = TextUtils.GetDefaultTextObject(125, 490, 3, Left, GameConfig.DefaultFontColor);
        friendsOnline.text = "Friends online: 2";
        addChild(friendsOnline);

        final coinRewards = TextUtils.GetDefaultTextObject(125, 530, 3, Left, GameConfig.DefaultFontColor);
        coinRewards.text = "Coins earned: 2000";
        addChild(coinRewards);

        final teethRewards = TextUtils.GetDefaultTextObject(125, 570, 3, Left, GameConfig.DefaultFontColor);
        teethRewards.text = "Teeth earned: 2000";
        addChild(teethRewards);

        // Invite button
        final inviteButton = new InviteFriendButton(this);
        inviteButton.setPosition(
            Main.ActualScreenWidth / 2,
            350
        );

        final interactionInvite = new h2d.Interactive(inviteButton.getWidth(), inviteButton.getHeight());
        interactionInvite.setPosition(
            Main.ActualScreenWidth / 2 - inviteButton.getWidth() / 2,
            350 - inviteButton.getHeight() / 2
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

        // Invitation rules
        final invitationRule1 = TextUtils.GetDefaultTextObject(125, 670, 3, Left, GameConfig.DefaultFontColor);
        invitationRule1.text = "Get 200 coins per invite";
        addChild(invitationRule1);

        final invitationRule2 = TextUtils.GetDefaultTextObject(125, 720, 3, Left, GameConfig.DefaultFontColor);
        invitationRule2.text = "Get 200 teeth per levelup";
        addChild(invitationRule2);

        // Friend scrolling container
        final topFriends = TextUtils.GetDefaultTextObject(125, 820, 3.5, Left, GameConfig.DefaultFontColor);
        topFriends.text = "TOP 10 friends:";
        addChild(topFriends);

        final friendsContainer = new ScrollingFriendsContainer(this);
        friendsContainer.setPosition(0, 900);

        friendsContainer.addFriend("Sofia", FriendStatus.PLAYING_POSSIBLE_TO_JOIN, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.PLAYING_NOT_POSSIBLE_TO_JOIN, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.ONLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
        friendsContainer.addFriend("Sofia", FriendStatus.OFFLINE, "200");
    }

    public function update(dt:Float) {
    }
  
}