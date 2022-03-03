// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ERC721Minter
 * @dev This Contract is used to interact with ERC721 Contract
 */
contract ERC721Minter is ERC721, Ownable {
    using SafeMath for uint256;
    using SafeMath for uint16;
    address private _mediaContract;

   
    mapping(uint256 => string) private _tokenURIs;

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return _tokenURIs[tokenId];
    }

    
    modifier onlyMediaCaller() {
        require(
            msg.sender == _mediaContract,
            "ERC721Minter: Unauthorized Access!"
        );
        _;
    }

    // TODO: Set Name & Symbol
    constructor() ERC721("Test Heritage", "Test Heritage") Ownable() { }

   /**
     * @notice This method is used to check if token with ID _tokenID exists
     * @param _tokenID ID of the token to check
     * @return true if token with ID _tokenID exists, false otherwise
     */
    function doesTokenExist(uint256 _tokenID)
        external
        view
        onlyMediaCaller
        returns (bool)
    {
        return _exists(_tokenID);
    }

    /**
     * @notice This method is used to mint a token
     * @param _tokenID ID of the token to mint
     * @param _owner Address of the token owner
     */
    function mintToken(
        uint256 _tokenID,
        address _owner,
        string memory _uri
    ) external  {
        _safeMint(_owner, _tokenID);
        _tokenURIs[_tokenID] = _uri;
    }

    function transferToken(
        address _tokenOwner,
        address _recipient,
        uint256 _tokenID
    ) external  {
        _safeTransfer(_tokenOwner, _recipient, _tokenID, "");
    }
}
