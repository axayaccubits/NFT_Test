// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Minter.sol";
import "./MarketProxy.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


    contract MarketFactory is OwnableUpgradeable{

    mapping(address=>address) public userToContractInstance;
    event instanceCreated(address creator,address ERC721,address marketProxy);

    //Create a new ERC721 instance
    function createInstance(string memory _name,
    string memory _symbol, 
    string memory _baseTokenURI,
    address MarketImplementationAddress,
    address _superAdmin) public returns (address){

        ERC721Minter ERC721Instance = new ERC721Minter();
        address ERC721MinterAdr = address(ERC721Instance);
        
        ERC721Instance.initialize(
            _name,
            _symbol,
            _baseTokenURI,
            _superAdmin
        );
        MarketProxy _MarketProxy = new MarketProxy();
        address ProxyMarket = address(_MarketProxy);

        _MarketProxy.initialize(ERC721MinterAdr,_superAdmin);
        _MarketProxy.upgradeTo(MarketImplementationAddress);
        
        userToContractInstance[msg.sender] = ERC721MinterAdr;
        emit instanceCreated(msg.sender,ERC721MinterAdr,ProxyMarket);
        return ERC721MinterAdr;
    }

    //initialize contract owner
     function initializeOwner() initializer public{
          __Ownable_init();
     }

    //add new creator only by admin
    function addCreator(address _creator,
    string memory _name,
    string memory _symbol, 
    string memory _baseTokenURI,
    address MarketImplementationAddress,
    address _superAdmin) public onlyOwner returns(address){

          ERC721Minter ERC721Instance = new ERC721Minter();
          address ERC721MinterAdr = address(ERC721Instance);

           ERC721Instance.initialize(
            _name,
            _symbol,
            _baseTokenURI,
            _superAdmin
        );
        MarketProxy _MarketProxy = new MarketProxy();
        address ProxyMarket = address(_MarketProxy);

        _MarketProxy.initialize(ERC721MinterAdr,_superAdmin);
        _MarketProxy.upgradeTo(MarketImplementationAddress);
        _MarketProxy.transferOwnership(_superAdmin);

        userToContractInstance[_creator] = ERC721MinterAdr;
        emit instanceCreated(_creator,ERC721MinterAdr,ProxyMarket);
        return ERC721MinterAdr;
    }

}