pragma solidity ^0.4.21;

/**
 * @title ItemFactory
 * @dev The ItemFactory contract creates the desired number of non-fungible items
 * and knows the owner of the each one.
 */
contract ItemFactory {

    // Item structure
    struct Item {
            uint32 itemId;
            uint32 itemStamp;
    }

    // List and number of the items
    Item[] item;
    uint numItems;

    mapping (uint => address) itemToOwner;
    mapping (address => uint) ownerItemCount;

    // Throws if called by any account other than the ownerOf
    modifier onlyOwnerOf(uint _itemId) {
       require(msg.sender == itemToOwner[_itemId]);
       _;
    }

    // Create 'numItems' non-fungible items owned by the creator of it
    function createItem(uint _numItems) internal {
        numItems = _numItems;

        for(uint i=0; i<_numItems; i++){
            item.push(Item(uint32(i), uint32(block.timestamp)));
            itemToOwner[i] = msg.sender;
            ownerItemCount[msg.sender]++;
        }

    }

}
