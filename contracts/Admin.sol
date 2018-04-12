pragma solidity ^0.4.21;

/**
 * @title Admin
 * @dev The Admin contract has an admin address, and provides basic authorization
 * control functions.
 */
contract Admin {

    address public admin;

    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    // Throws if called by any account other than the admin
    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    // The Admin constructor sets the original `admin` of the contract to the sender account
    function Admin() public {
        admin = msg.sender;
    }

    //TODO: implement the change of the owner of items in case of transferred the admin
    /* // Allows the current admin to transfer the permissions over the contract to a newAdmin
    function transferAdmin(address _newAdmin) public onlyAdmin {
      require(_newAdmin != address(0));
      emit AdminTransferred(admin, _newAdmin);
      admin = _newAdmin;
    } */

}
