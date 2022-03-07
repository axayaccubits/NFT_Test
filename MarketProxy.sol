// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StorageStructure.sol";

contract MarketProxy is StorageStructure {

    modifier onlyCreator() {
        require (msg.sender == instanceCreator
        || msg.sender == owner()
        , "msg.sender is not an owner");
        _;
    }

    event ImplementationUpgraded();

  
    constructor() {
        instanceCreator = msg.sender;
        upgradeEnabled = true;
    }

    /**
     * @notice This is called in case we want to upgrade a working market which inherits from
            the original implementation, to apply bug fixes and consider emergency cases.
    */
    function upgradeTo(address _newMarketImplementationAddress) external onlyCreator {
        require(upgradeEnabled, "Upgrade is not enabled yet");
        require(
            MarketImplementationAddress != _newMarketImplementationAddress, 
            "Is already the implementation"
        );
        _setNewMarketImplementationAddress(_newMarketImplementationAddress);
        upgradeEnabled = false;
    }

    /**
     * @notice NewMarketImplementationAddress can't be upgraded unless superAdmin sets upgradeEnabled
     */
    function enableUpgrade() external onlyOwner{
        upgradeEnabled = true;
    }

    function disableUpgrade() external onlyOwner{
        upgradeEnabled = false;
    }

  
     /// @dev we should call inits because we don't have a constructor to do it for us
    function initialize(address _ERC721Address,address _superAdmin) public initializer onlyCreator
    {
        ERC721Address = _ERC721Address;
        _adminAddress = _superAdmin;
       
    }

    fallback() external payable {
        address opr = MarketImplementationAddress;
        require(opr != address(0));
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), opr, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
    
    receive() external payable {}

    function _setNewMarketImplementationAddress(address _newMarketImplementationAddress) internal {
        MarketImplementationAddress = _newMarketImplementationAddress;
        emit ImplementationUpgraded();
    }
}
