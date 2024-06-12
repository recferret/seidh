message(0x5fcc3d14) Transfer {
    query_id: Int as uint64;
    new_owner: Address;
    response_destination: Address?;
    forward_amount: Int as coins;
    forward_payload: Slice as remaining;
}

message(0xd53276db) Excesses {
    query_id: Int as uint64;
}

message CollectionData {
    next_item_index: Int;
    collection_content: Cell;
    owner_address: Address;
}

message ItemData {
    owner: Address;
    collection_address: Address;
    item_index: Int;
    individual_content: Cell;
}