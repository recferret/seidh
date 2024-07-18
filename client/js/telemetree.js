let _telemetreeBuilder = undefined;

function telemetreeInit(isTelegramContext) {
    _telemetreeBuilder = telemetree({
        projectId: "864fd7b7-b5d7-4789-86f5-1026d65a9715",
        apiKey: "55e1bee8-e53e-4bc5-9742-a2fb156b437b",
        appName: "Seidh-game",
        isTelegramContext, 
    });
}

// -----------------------------------------
// Main screen events
// -----------------------------------------

function trackHomeClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('home_click');
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

function trackLvlUpClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('lvl_up_click');
}

function trackChangeCharacterClick() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('change_character_click');
}

// -----------------------------------------
// Boost screen events
// -----------------------------------------

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

function trackGameStarted() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_started');
}

function trackGameWin() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_win');
}

function trackGameLose() {
    if (_telemetreeBuilder)
        _telemetreeBuilder.track('game_lose');
}