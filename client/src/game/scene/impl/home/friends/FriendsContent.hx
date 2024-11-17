package game.scene.impl.home.friends;

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

        final friendDetails = new h2d.Text(font);
        friendDetails.text = friendNameText + statusText + lvl;
        friendDetails.textColor = GameConfig.FontColor;
        friendDetails.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendDetails.textAlign = Left;
        friendDetails.setScale(3);
        friendDetails.setPosition(65, 0);
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

        final font : h2d.Font = DefaultFont.get();

        final friendsInvited = new h2d.Text(font);
        friendsInvited.text = "Friends invited: 10";
        friendsInvited.textColor = GameConfig.FontColor;
        friendsInvited.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendsInvited.textAlign = Left;
        friendsInvited.setScale(3);
        friendsInvited.setPosition(125, 450);
        addChild(friendsInvited);

        final friendsOnline = new h2d.Text(font);
        friendsOnline.text = "Friends online: 2";
        friendsOnline.textColor = GameConfig.FontColor;
        friendsOnline.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        friendsOnline.textAlign = Left;
        friendsOnline.setScale(3);
        friendsOnline.setPosition(125, 490);
        addChild(friendsOnline);

        final coinRewards = new h2d.Text(font);
        coinRewards.text = "Coins earned: 2000";
        coinRewards.textColor = GameConfig.FontColor;
        coinRewards.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        coinRewards.textAlign = Left;
        coinRewards.setScale(3);
        coinRewards.setPosition(125, 530);
        addChild(coinRewards);

        final teethRewards = new h2d.Text(font);
        teethRewards.text = "Teeth earned: 2000";
        teethRewards.textColor = GameConfig.FontColor;
        teethRewards.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        teethRewards.textAlign = Left;
        teethRewards.setScale(3);
        teethRewards.setPosition(125, 570);
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
        final invitationRule1 = new h2d.Text(font);
        invitationRule1.text = "Get 200 coins per invite";
        invitationRule1.textColor = GameConfig.FontColor;
        invitationRule1.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        invitationRule1.textAlign = Left;
        invitationRule1.setScale(3);
        invitationRule1.setPosition(125, 670);
        addChild(invitationRule1);

        final invitationRule2 = new h2d.Text(font);
        invitationRule2.text = "Get 200 teeth per levelup";
        invitationRule2.textColor = GameConfig.FontColor;
        invitationRule2.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        invitationRule2.textAlign = Left;
        invitationRule2.setScale(3);
        invitationRule2.setPosition(125, 720);
        addChild(invitationRule2);

        // Friend scrolling container
        final topFriends = new h2d.Text(font);
        topFriends.text = "TOP 10 friends:";
        topFriends.textColor = GameConfig.FontColor;
        topFriends.dropShadow = { dx : 0.5, dy : 0.5, color : 0xFF0000, alpha : 0.8 };
        topFriends.textAlign = Left;
        topFriends.setScale(3.5);
        topFriends.setPosition(125, 820);
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