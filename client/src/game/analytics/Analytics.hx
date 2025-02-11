package game.analytics;

import game.js.NativeWindowJS;

class Analytics {
    
    public static final instance: Analytics = new Analytics();

	private function new() {
	}

    public function telemetreeInit() {
        NativeWindowJS.telemetreeInit();
    }

    public function trackHomeClick() {
        NativeWindowJS.trackHomeClick();
    }
    
    public function trackBoostsClick() {
        NativeWindowJS.trackBoostsClick();
    }
    
    public function trackCollectionClick() {
        NativeWindowJS.trackCollectionClick();
    }
    
    public function trackFriendsClick() {
        NativeWindowJS.trackFriendsClick();
    }
    
    // -----------------------------------------
    // Home screen events
    // -----------------------------------------
    
    public function trackPlayClick() {
        NativeWindowJS.trackPlayClick();
    }

    public function trackCharacterInfoClick() {
        NativeWindowJS.trackCharacterInfoClick();
    }
    
    public function trackCharacterLvlUpClick() {
        NativeWindowJS.trackCharacterLvlUpClick();
    }
    
    public function trackCharacterChangeClick() {
        NativeWindowJS.trackCharacterChangeClick();
    }
    
    // -----------------------------------------
    // Boost screen events
    // -----------------------------------------
    
    public function trackBoostClick(boostId, owned, coins, teeth) {
        NativeWindowJS.trackBoostClick(boostId, owned, coins, teeth);
    }
    
    public function trackBoostDialogClick(boostId, action, owned, coins, teeth) {
        NativeWindowJS.trackBoostDialogClick(boostId, action, owned, coins, teeth);
    }

    public function trackBoostBuyResult(boostId, success) {
        NativeWindowJS.trackBoostBuyResult(boostId, success);
    }
    
    // -----------------------------------------
    // Collection screen events
    // -----------------------------------------
    
    public function trackWalletConnectClick() {
        NativeWindowJS.trackWalletConnectClick();
    }
    
    public function trackWalletConnected(address) {
        NativeWindowJS.trackWalletConnected(address);
    }
    
    public function trackMintRagnarClick() {
        NativeWindowJS.trackMintRagnarClick();
    }
    
    // -----------------------------------------
    // Friends screen events
    // -----------------------------------------
    
    public function trackInviteFriendClick() {
        NativeWindowJS.trackInviteFriendClick();
    }
    
    // -----------------------------------------
    // Gameplay events
    // -----------------------------------------
    
    public function trackGameStarted(gameId: String) {
        NativeWindowJS.trackGameStarted(gameId);
    }
    
    public function trackGameClosed(gameId: String) {
        NativeWindowJS.trackGameClosed(gameId);
    }
    
    public function trackGameWin(gameId: String) {
        NativeWindowJS.trackGameWin(gameId);
    }
    
    public function trackGameLose(gameId: String) {
        NativeWindowJS.trackGameLose(gameId);
    }

}