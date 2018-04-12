pragma solidity ^0.4.21;

import "./ERC721.sol";
import "./ItemFactory.sol";

/**
 * @title ItemOwnership
 * @dev The ItemOwnership contract is an implementation of the ERC721 standard
 * oriented to an open multi-item auction.
 */
contract ItemOwnership is ItemFactory, ERC721 {

    mapping (uint => address) itemApprovals;

    // ERC20-like functions
    function name() public view returns (string _name){
        return "Auction Item";
    }

    function symbol() public view returns (string _symbol){
        return "⚖️";
    }

    function totalSupply() public view returns (uint256 _totalSupply){
        return numItems;
    }

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerItemCount[_owner];
    }

    // Ownership functions
    function ownerOf(uint256 _itemId) public view returns (address _owner) {
        return itemToOwner[_itemId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerItemCount[_to]++;
        ownerItemCount[_from]--;
        itemToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        itemApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(itemApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }

    //No-ERC721 functions
    function getItem(uint _position) internal view returns (uint) {
        return item[_position].itemId;
    }

}
