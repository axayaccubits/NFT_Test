// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Minter.sol";

contract ERC721Factory{

    mapping(address=>address) public userToContractInstance;
    event instanceCreated(address creator,address instance);

    function createInstance() public returns (address){

        ERC721Minter ERC721Instance = new ERC721Minter();
        address ERC721MinterAdr = address(ERC721Instance);
        userToContractInstance[msg.sender] = ERC721MinterAdr;
        emit instanceCreated(msg.sender,ERC721MinterAdr);
        return ERC721MinterAdr;
    }

}