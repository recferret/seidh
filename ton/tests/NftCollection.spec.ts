import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { NftCollection } from '../wrappers/NftCollection';
import { NftItem } from '../wrappers/NftItem';
import '@ton/test-utils';

describe('NftCollection', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let user1: SandboxContract<TreasuryContract>;
    let user2: SandboxContract<TreasuryContract>;
    let nftCollection: SandboxContract<NftCollection>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        nftCollection = blockchain.openContract(await NftCollection.fromInit());

        deployer = await blockchain.treasury('deployer');

        user1 = await blockchain.treasury('user1');
        user2 = await blockchain.treasury('user2');

        const deployResult = await nftCollection.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: nftCollection.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        console.log('user1.address: ' + user1.address);
        // console.log('user2.address: ' + user2.address);
        console.log('deployer.address: ' + deployer.address);
    });

    it('should mint NFT', async () => {
        // console.log(await nftCollection.getGetCollectionData());

        await nftCollection.send(user1.getSender(), {
            value: toNano("0.17")    
        }, "Mint");

        // console.log(await nftCollection.getGetCollectionData());

        const nftItemAddress = await nftCollection.getGetNftAddressByIndex(0n);
        const nftItem: SandboxContract<NftItem> = blockchain.openContract(NftItem.fromAddress(nftItemAddress));
        const nftItemData = await nftItem.getGetItemData();
        console.log(nftItemData);


        // await nftCollection.send(user2.getSender(), {
        //     value: toNano("5.4")    
        // }, "Mint");

        // const nftItemAddress2 = await nftCollection.getGetNftAddressByIndex(1n);
        // const nftItem2: SandboxContract<NftItem> = blockchain.openContract(NftItem.fromAddress(nftItemAddress2));
        // // const nftItemData2 = await nftItem2.getGetItemData();

        // console.log(nftItem2);

        // console.log(nftItemAddress);
        // console.log(nftItemAddress2);

        // const nftItemData2 = await nftItem2.getGetItemData();

        // await nftCollection.send(user1.getSender(), {
        //     value: toNano("5.3")    
        // }, "Mint");

        // const nftItemAddress3 = await nftCollection.getGetNftAddressByIndex(2n);
        // const nftItem3: SandboxContract<NftItem> = blockchain.openContract(NftItem.fromAddress(nftItemAddress3));
        // const nftItemData3 = await nftItem3.getGetItemData();

        // console.log(nftItemData);
        // console.log(nftItemData2.individual_content.beginParse().loadStringTail());
        // console.log(nftItemData3.individual_content.beginParse().loadStringTail());

    });

    // it('should mint NFT', async () => {
    //     await nftCollection.send(user1.getSender(), {
    //         value: toNano("5.3")    
    //     }, "Mint");

    //     console.log(await nftCollection.getGetCollectionData());

    //     const nftItemAddress = await nftCollection.getGetNftAddressByIndex(1n);
    //     const nftItem: SandboxContract<NftItem> = blockchain.openContract(NftItem.fromAddress(nftItemAddress));
    //     const nftItemData = await nftItem.getGetItemData();

    //     console.log(nftItemData.individual_content.beginParse().loadStringTail());
    // });

});
