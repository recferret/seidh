let _telemetreeBuilder = undefined;

function telemetreeInit() {
    _telemetreeBuilder = telemetree({
        projectId: "eb91268b-934f-4c6a-b819-fef11d12cdd2",
        apiKey: "ab8a9a1f-3b03-4a37-ae2d-f1965ac540c4",
        appName: "verynimbleferret",
        isTelegramContext: true, 
    });
}

// -----------------------------------------
// Main screen events
// -----------------------------------------

function trackHomeClick() {
    if (_telemetreeBuilder) {
        _telemetreeBuilder.track('home_click');
    }
}

function trackBoostsClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('boosts_click');
}

function trackCollectionClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('collections_click');
}

function trackFriendsClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('friends_click');
}

// -----------------------------------------
// Home screen events
// -----------------------------------------

function trackPlayClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('play_click');
}

function trackCharacterInfoClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('character_info_click');
}

function trackCharacterLvlUpClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('character_lvl_up_click');
}

function trackCharacterChangeClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('character_change_click');
}

// -----------------------------------------
// Boost screen events
// -----------------------------------------

function trackBoostClick(boostId, owned, coins, teeth) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('boost_click', {
            boostId, owned, coins, teeth,
        });
}

function trackBoostDialogClick(boostId, action, owned, coins, teeth) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('boost_dialog_click', {
            boostId, action, owned, coins, teeth,
        });
}

function trackBoostBuyResult(boostId, success) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('boost_buy_result', {
            boostId, success,
        });
}

// -----------------------------------------
// Collection screen events
// -----------------------------------------

function trackWalletConnectClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('wallet_connect_click');
}

function trackWalletConnected(address) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('wallet_connected', {
            address
        });
}

function trackMintRagnarClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('mint_ragnar_click');
}

// -----------------------------------------
// Friends screen events
// -----------------------------------------

function trackInviteFriendClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('invite_friend_click');
}

// -----------------------------------------
// Gameplay events
// -----------------------------------------

function trackGameStarted(gameId) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_started', {
            gameId,
        });
}

function trackGameClosed(gameId) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_closed', {
            gameId,
        });
}

function trackGameWin(gameId) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_win', {
            gameId,
        });
}

function trackGameLose(gameId) {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_lose', {
            gameId,
        });
}