pragma solidity ^0.4.21;

import "./LinkedList.sol"; // Linked list library
import "./Admin.sol"; // Admin permissions modifiers
import "./ItemOwnership.sol"; //ERC721 item implementation

/**
 * @title OpenMultiAuction
 * @dev The OpenMultiAuction contract implements an open auction with several
 * objects (only one modificable bid per bidder) using an auto sorted linked list
 * structure. It has an admin to control de auction steps and the bids/bidders.
 */
contract OpenMultiAuction is Admin, ItemOwnership {

    // Load the linked list object from library with their own functions
    using LinkedList for LinkedList.List;

    // The provisional time of auction (Unix timestamp)
    uint public auctionEnd;

    // Status of the Bid variables
    enum AuctionStatus { open, preclose, close, cancel}
    AuctionStatus public status;

    // Linked list of the Bids
    LinkedList.List public bids;

    address[] winners;

    // Events that will be fired on state changes
    event AuctionOpened(uint totalItems, uint timestamp);
    event BidAdded(address indexed bidder, uint timestamp);
    event BidDeleted(address indexed bidder, uint timestamp);
    event AuctionPreClosed(uint timestamp);
    event AuctionClosed(uint timestamp);
    event AuctionReOpened(uint timestamp);
    event AuctionCancelled(uint timestamp);

    // Time modifiers
    modifier beforeOnly { require(block.timestamp < auctionEnd); _; }
    modifier afterOnly { require(block.timestamp > auctionEnd); _; }

    /*** Constructor ***/

    // Create a simple auction with `openTime` seconds bidding time and 'numItems' of items in it.
    function OpenMultiAuction(uint _openTime, uint _numItems) public {
        auctionEnd = block.timestamp + _openTime;
        status = AuctionStatus.open;
        createItem(_numItems); //FROM: ItemFactory
        emit AuctionOpened(_numItems, block.timestamp);
    }

    /*** Auction Administration ***/

    // Pre-close the auction
    function auctionPreClose() external onlyAdmin {
        require(status == AuctionStatus.open);
        status = AuctionStatus.preclose;
        emit AuctionPreClosed(block.timestamp);
    }

    // Re-open the auction
    function auctionReOpen() external onlyAdmin {
        require(status == AuctionStatus.preclose);
        status = AuctionStatus.open;
        emit AuctionReOpened(block.timestamp);
    }

    // CLose the auction
    function auctionClose() external onlyAdmin {
        require(status == AuctionStatus.preclose);
        status = AuctionStatus.close;
        emit AuctionClosed(block.timestamp);
        transferToWinners();
    }

    // Cancel the auction
    function auctionCancel() external onlyAdmin {
        require(status != AuctionStatus.cancel);
        status = AuctionStatus.cancel;
        emit AuctionCancelled(block.timestamp);
    }

    /*** Bids Administration ***/

    // Bid given an amount
    function bid(uint _amount) external beforeOnly {
        require(status == AuctionStatus.open);
        bids.addElement(msg.sender, _amount);
        emit BidAdded(msg.sender, block.timestamp);
    }

    // Delete a given bidder of the list
    function deleteBidder(address _bidder) external onlyAdmin {
        bids.deleteElement(_bidder);
        emit BidDeleted(_bidder, block.timestamp);
    }

    // Retun a bidder data
    function getBidder(address _bidder) external view returns (uint, address, address){
        return bids.getElement(_bidder);
    }

    // Return an array with the 'totalSupply()' first bidders in the list
    function getWinners() internal {
        address nextWinner = bids.head;
        uint nItems = totalSupply();
        for (uint i = 0; i < nItems; i++){
             winners.push(nextWinner);
             (,,nextWinner) = bids.getElement(nextWinner);
        }
    }

    /*** Item Administration ***/

    //Tranfer the items ownership to their owners
    function transferToWinners() internal onlyAdmin {
        uint nItems = totalSupply();
        getWinners();
        for (uint i = 0; i < nItems; i++){
            transfer(winners[i], getItem(i));
        }
    }

}
