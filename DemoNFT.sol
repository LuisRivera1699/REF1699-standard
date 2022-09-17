// SPDX-License-Identifier: MIT
// Creator: https://twitter.com/xisk1699

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './REF1699.sol';

contract DemoNFT is Ownable, REF1699, ReentrancyGuard {

    uint16 public immutable MAX_TEAM_SUPPLY = 150;
    uint16 public teamCounter = 0;

    address private immutable CEO_ADDRESS = 0x8306865FAb8dEC66a1d9927d9ffC4298500cF7Ed;
    string public baseTokenURI;

    uint8 public saleStage; // 0: PAUSED | 1: SALE | 2: SOLDOUT

    constructor() REF1699('Demo NFT', 'DEMONFT', 20, 3333, 1, 10) {
        saleStage = 0;
    }

    // UPDATE SALESTAGE

    function setSaleStage(uint8 _saleStage) external onlyOwner {
        require(saleStage != 2, "Cannot update if already reached soldout stage.");
        saleStage = _saleStage;
    }

    // PUBLIC MINT 

    function publicMint(uint _quantity, address referrer) external payable nonReentrant {
        require(saleStage == 1, "Sale is not active.");
        require(_quantity <= maxBatchSize, "Max mint at onece exceeded.");
        require(balanceOf(msg.sender) + _quantity <= 20, "Would reach max NFT per holder.");
        require(msg.value >= 0.015 ether * _quantity, "Not enough ETH.");
        require(totalSupply() + _quantity + (MAX_TEAM_SUPPLY-teamCounter) <= collectionSize, "Mint would exceed max supply.");
        require(msg.sender != referrer, "You cannot refer yourself.");

        // Implement the referrer royalty based on collection logic
        if (referrer != address(0)) {
            _sendReferrerRoyalty(referrer);
        }

        _safeMint(msg.sender, _quantity);

        if (totalSupply() + (MAX_TEAM_SUPPLY-teamCounter) == collectionSize) {
            saleStage = 2;
        }
    }

    // TEAM MINT

    function teamMint(address _to, uint16 _quantity) external onlyOwner {
        require(teamCounter + _quantity <= MAX_TEAM_SUPPLY, "Would exceed max team supply.");
        _safeMint(_to, _quantity);
        teamCounter += _quantity;
    }
    
    // METADATA URI

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseTokenUri(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexisting token");
        string memory base = _baseURI();
        return bytes(base).length > 0 ? string(abi.encodePacked(base, Strings.toString(tokenId), ".json")) : "";
    }

    // WITHDRAW

    function withdraw() external onlyOwner {
        uint256 ethBalance = address(this).balance;
        payable(CEO_ADDRESS).transfer(ethBalance);
    }
}