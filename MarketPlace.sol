
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./StorageStructure.sol";
import "./ERC721Minter.sol";

contract MarketPlace is StorageStructure{

    
modifier whenTokenExist(uint256 _tokenID) {
        require(
            _tokenIDToToken[_tokenID]._artist != address(0),
            "Media: The Token Does Not Exist!"
        );
        _;
    }

    modifier onlyAdmin() {
        require(_adminAddress == msg.sender, "Media: Unauthorized Access!");
        _;
    }

    fallback() external {}

    receive() external payable {}

   
    function mint(
        Token memory _newToken,
        uint16 _royaltyPoints,
        string calldata _tokenSellingType,
        bytes calldata signature
    ) private {
       
       
        //_mintToken(_newToken, _royaltyPoints);
    }

    // *** Admin Methods End ***

    function getAdminAddress() external view returns (address) {
        return _adminAddress;
    }

    
    // *** User Methods End ***
}
