 
 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract StorageStructure is OwnableUpgradeable {

     struct Bid {
        address _bidder;
        uint256 _bidAmount;
    }

    struct Token {
        string _title;
        string _uri;
        address _artist;
        uint256 _bidDuration;
        uint256 _price;
    }

    event MintToken(
        uint256 _royaltyPoints,
        string _uri,
        string _title,
        address _owner
    );
    // tokenID => Bid Expire Time(In Seconds since Epoch)
    mapping(uint256 => uint256) public _tokenAuctionEndTime;
    mapping(uint256 => Bid) public _tokenBids;

    uint256 _tokenCounter;
    
    address public MarketImplementationAddress;
    address public ERC721Address;

    address public _adminAddress;
    address public instanceCreator;

    bool public upgradeEnabled;

    // tokenID => Owner
    mapping(uint256 => address) public _nftToOwners;

    // tokenID => Creator
    mapping(uint256 => address) public _nftToCreators;

    // tokenID => Token
    mapping(uint256 => Token) public _tokenIDToToken;

     event BidPlace(uint256 _tokenID, address _bidder, uint256 _bidAmount);
     event Claim(uint _tokenID, address _tokenOwner, address _recipient);
     event Buy(uint _tokenID, address _from , address _recipient);
     event TokenCounter(uint256 _tokenCounter);

    
}
 