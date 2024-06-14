async function tonConnect() {
    const tonConnectUI = new TON_CONNECT_UI.TonConnectUI({
        manifestUrl: 'https://seidh-game.online/assets/ton_manifest.json',
    });

    await tonConnectUI.openModal();

    // const Address = TonWeb.utils.Address;
    // const address = new Address(currentAccount.address);
    // console.log(address.toString(true));
}

async function tonMintRagnar() {
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

    try {
        const result = await tonConnectUI.sendTransaction(transaction);
        const someTxData = await myAppExplorerService.getTransaction(result.boc);
        alert('Transaction was sent successfully', someTxData);
    } catch (e) {
        console.error(e);
    }
}