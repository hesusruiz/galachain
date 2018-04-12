pragma solidity ^0.4.21;

/**
 * @title ERC721 minimal Interface
 * @dev The ERC721 is an abstract contract implementing an ERC721 standard interface.
 */
contract ERC721 {

    // Events
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    // ERC20-like functions
    function name() public view returns (string _name);
    function symbol() public view returns (string _symbol);
    function totalSupply() public view returns (uint256 _totalSupply);
    function balanceOf(address _owner) public view returns (uint256 _balance);

    // Ownership functions
    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function transfer(address _to, uint256 _tokenId) public;
    function approve(address _to, uint256 _tokenId) public;
    function takeOwnership(uint256 _tokenId) public;

}
