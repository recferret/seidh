let _tonConnectUI = undefined; 
let _connectedWallet = undefined; 

async function initTonConnect() {
    if (!_tonConnectUI)  {
        _tonConnectUI = new TON_CONNECT_UI.TonConnectUI({
            manifestUrl: 'https://api.seidh-game.com/assets/ton_manifest.json',
        });
        _connectedWallet = await _tonConnectUI.connectWallet();
    }
}

async function tonConnect(callback) {
    await initTonConnect();

    try {
        if (_connectedWallet.account) {
            const address = new TonWeb.utils.Address(_connectedWallet.account.address).toString(true);
            callback(address);
        } else {
            alert('No account');
        }
    } catch (e) {
        alert('Wallet connection error', e);
    }
}

async function tonDisconnect(callback) {
}

async function tonMintRagnar() {
    // await initTonConnect();

    try {
        const a = new TonWeb.boc.Cell();
        a.bits.writeUint(0, 32);
        a.bits.writeString("Mint");
        const payload = TonWeb.utils.bytesToBase64(await a.toBoc());

        const transaction = {
            validUntil: Math.floor(Date.now() / 1000) + 360,
            messages: [
                {
                    address: "EQCISLAfh-0JEPcpSpBG3yqr-VDHZX7GImjSIYGnUGH--E0r",
                    amount: "170000000",
                    payload
                }
            ]
        }

        const result = await _tonConnectUI.sendTransaction(transaction);
        // const someTxData = await myAppExplorerService.getTransaction(result.boc);
        // alert('Transaction was sent successfully', someTxData);
    } catch (e) {
        console.error(e);
        alert('Transaction error', e);
    }
}