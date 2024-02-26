// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {
    //custom errors
    error ONLY_OWNER_CAN_SELL_NFT();
    error NFT_NOT_FOR_SALE();
    error ONLY_OWNER_CAN_MINT_NFT();

    address public owner;
    uint256 public tokenId = 1;

    struct NFT {
        address owner;
        bool forSale;
        uint256 price;
    }

    mapping(uint256 => NFT) public nfts;

    constructor() ERC721(" Lawrenzo NFT Marketplace", "NFTLAW") {
        owner = msg.sender;
    }

    function mintNFT(address _owner, uint256 _price) public returns (uint256) {
        if (msg.sender != owner) {
            revert("ONLY_OWNER_CAN_MINT_NFT");
        }
        uint256 newTokenId = tokenId++;
        _safeMint(_owner, newTokenId);
        nfts[newTokenId] = NFT(_owner, false, _price);
        return newTokenId;
    }

    function sellNFT(uint256 _tokenId, uint256 _price) public {
        if (msg.sender != nfts[_tokenId].owner) {
            revert("ONLY_OWNER_CAN_SELL_NFT");
        }
        require(nfts[_tokenId].forSale == false, "NFT ready for  sale");
        nfts[_tokenId].price = _price;
        nfts[_tokenId].forSale = true;
    }

    function purchaseNFT(uint256 _tokenId) public payable {
        if (nfts[_tokenId].forSale != true) {
            revert("NFT_NOT_FOR_SALE");
        }
        require(
            msg.value >= nfts[_tokenId].price,
            "insufficient funds to buy NFT"
        );
        address seller = nfts[_tokenId].owner;
        nfts[_tokenId].forSale = false;
        nfts[_tokenId].price = 0;
        _transfer(seller, msg.sender, _tokenId);
    }

    function transferOwnership(address _newOwner) public {
        isOwner();
        require(_newOwner != address(0), "zero address detected");
        owner = _newOwner;
    }

    function isOwner() private view returns (bool) {
        return msg.sender == owner;
    }
}
