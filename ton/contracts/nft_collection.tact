import "@stdlib/deploy";
import "@stdlib/ownable";
import "./nft_item.tact";
import "./messages.tact";

const minTonForStorage: Int = ton("0.03");
const gasConsumption: Int = ton("0.03");

contract NftCollection with Deployable, Ownable {
    const mintPrice: Int = ton("0.1");
    const collectionMaxSize: Int = 200;

    owner: Address;
    next_item_index: Int as uint32 = 0;
    collection_content: String;

    init() {
        self.owner = sender();
        self.collection_content = "Seidh very first collection to support the development. It consists of 200 alpha Ragnars.";
    }

    receive("Mint") {
        self.mint(sender());
    }

    fun mint(receiver: Address) {
        require(self.next_item_index >= 0, "non-sequential NFTs");
        require(self.next_item_index + 1 < self.collectionMaxSize, "Max collection size rached");

        let msgValue: Int = context().value;
        let tonBalanceBeforeMsg: Int = myBalance() - msgValue;
        let storageFee: Int = minTonForStorage - min(tonBalanceBeforeMsg, minTonForStorage);
        
        require(msgValue - (storageFee + gasConsumption) >= self.mintPrice, "Not enought value for mint");

        msgValue = msgValue - (storageFee + gasConsumption) - self.mintPrice;

        let nft_init: StateInit = self.getNftItemInit(self.next_item_index);

        send(SendParameters {
            to: contractAddress(nft_init),
            value: msgValue,
            bounce: false,
            mode: SendIgnoreErrors,
            body: Transfer {
                query_id: 0,
                new_owner: receiver,
                response_destination: receiver,
                forward_amount: 0,
                forward_payload: emptySlice()
            }.toCell(),
            code: nft_init.code,
            data: nft_init.data,
        });

        self.next_item_index = self.next_item_index + 1;
    }

    get fun getNftItemInit(item_index: Int): StateInit {
        let b: StringBuilder = beginString();
        b.append("Alpha Ragnar - ");
        b.append((item_index + 1).toString());
        b.append(" of ");
        b.append(self.collectionMaxSize.toString());
        return initOf NftItem(self.owner, myAddress(), item_index, b.toString());
    }

    get fun get_nft_address_by_index(item_index: Int): Address {
        let initCode: StateInit = self.getNftItemInit(item_index);
        return contractAddress(initCode);
    }

    get fun get_collection_data(): CollectionData {
        return CollectionData {
            next_item_index: self.next_item_index,
            collection_content: self.collection_content.asSlice().asCell(),
            owner_address: self.owner
        };
    }
}
