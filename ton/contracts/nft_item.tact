import "@stdlib/deploy";
import "@stdlib/ownable";
import "./messages.tact";

contract NftItem with Deployable, Ownable {
    // Empty init() function is present by default in all Tact contracts
    // since v1.3.0, so the following may be omitted:
    
    owner: Address;
    collection_address: Address;
    item_index: Int;
    individual_content: String;

    init(
        owner: Address,
        collection_address: Address,
        item_index: Int,
        individual_content: String
    ) {
        self.owner = owner;
        self.collection_address = collection_address;
        self.item_index = item_index;
        self.individual_content = individual_content;
    }

    receive(msg: Transfer) {
        let ctx: Context = context(); // Reference: https://docs.tact-lang.org/language/ref/common#context
        let msgValue: Int = self.msgValue(ctx.value);
        self.owner = msg.new_owner;

        send(SendParameters{
            to: msg.response_destination!!,
            value: msgValue,
            mode: SendPayGasSeparately,
            body: Excesses { query_id: msg.query_id }.toCell()
        });
    }

    get fun get_item_data(): ItemData {
        return ItemData {
            owner: self.owner,
            collection_address: self.collection_address,
            item_index: self.item_index,
            individual_content: self.individual_content.asSlice().asCell()
        };
    }

    fun msgValue(value: Int): Int {
        let tonBalanceBeforeMsg: Int = myBalance() - value;
        let storageFee: Int = minTonForStorage - min(tonBalanceBeforeMsg, minTonForStorage);
        return value - (storageFee + gasConsumption);
    }
}
