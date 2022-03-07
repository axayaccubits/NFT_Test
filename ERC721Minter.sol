// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";

/**
 * @title ERC721Minter
 * @dev This Contract is used to interact with ERC721 Contract
 */
contract ERC721Minter is ERC721Upgradeable,
    
    OwnableUpgradeable,
    ERC721EnumerableUpgradeable {
    using SafeMath for uint256;
    using SafeMath for uint16;
    using StringsUpgradeable for uint256;

    string private _baseTokenURI;
    address public superAdmin;

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    mapping(uint256 => string) private _tokenURIs;
    // storing the royalty details of a token
    mapping(uint256 => Royalties) private _royalties;
    event RoyaltyAdded(uint256 indexed tokenId, address indexed account, uint256 percentage);
    event SuperAdminSet(address _newSuperAdmin);

    struct Royalties{
        address account;
        uint percentage;
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _BaseUri,
        address _newSuperAdmin

    ) public virtual initializer {
        __ERC721_init(_name, _symbol);
        __Context_init_unchained();
        __ERC165_init_unchained();
        __Ownable_init_unchained();
        setSuperAdmin(_newSuperAdmin);
        _baseTokenURI = _BaseUri;
      }

    function setSuperAdmin(address _newOwner) internal onlyOwner returns (address){
        require(_newOwner != address(0),"0 address aasigned");
        superAdmin = _newOwner;
        emit SuperAdminSet(superAdmin);
        return superAdmin;
    }

    function getSuperAdmin() external view returns (address){
        return superAdmin;
    }

     function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        
        bytes memory tempBytes = bytes(_tokenURI);
        if(tempBytes.length > 0) _tokenURIs[tokenId] = _tokenURI;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Upgradeable,ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

     /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        // add support to EIP-2981: NFT Royalty Standard
        if(interfaceId == _INTERFACE_ID_ERC2981){
            return true;
        }
        return super.supportsInterface(interfaceId);
    }

    /**
     * @notice This method is used to mint a token
     * @param _tokenID ID of the token to mint
     * @param _owner Address of the token owner
     */
    function mintToken(
        uint256 _tokenID,
        address _owner,
        string memory _uri,
        Royalties calldata royalties
    ) external  {
        _safeMint(_owner, _tokenID);
        _tokenURIs[_tokenID] = _uri;
        _setRoyalties(_tokenID, royalties);
    }

     function _setRoyalties(uint256 collectibleId, Royalties calldata royalties) internal virtual {
        
        require(royalties.percentage <= 8000, "royalty % shouldn't be less than 80");
        
        if(royalties.account != address(0)){
            _royalties[collectibleId] = royalties;
            emit RoyaltyAdded(collectibleId, royalties.account, royalties.percentage);
        }
    }
    
     function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    ) external view returns (
        address receiver,
        uint256 royaltyAmount
    ){
        require(_exists(_tokenId), "query for non nonexistent token");
        
        royaltyAmount = (_salePrice * _royalties[_tokenId].percentage) / 10000;
        receiver = _royalties[_tokenId].account;
    }

    function transferToken(
        address _tokenOwner,
        address _recipient,
        uint256 _tokenID
    ) external  {
        _safeTransfer(_tokenOwner, _recipient, _tokenID, "");
    }
}
