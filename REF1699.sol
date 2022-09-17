// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import './ERC721A.sol';

/// @title A Standard for NFTs Referrer Systems
/// @author Luis Rivera https://www.linkedin.com/in/luisrivera1699/
/// @notice You can extend this contract in your NFT collection Smart Contract to implement referrer system logic.
/// @dev This is an initial implementation for the Standard, more features will be included in next versions.
contract REF1699 is ERC721A {

    /// @dev Defines the royalty percentage per referrer mint to non-holder wallets
    uint public immutable NON_HOLDER_REFERRER_ROYALTY;

    /// @dev Defines the royalty percentage per referrer mint to holder wallets
    uint public immutable HOLDER_REFERRER_ROYALTY;

    /// @dev Defines the mapping that will bind token to referrer wallet
    mapping (uint => address) public referrerMapping;

    /// @notice Constructor for the Referrer System Standard
    /// @dev Constructor params are for setting the referrer royalties and instantiating the ERC721A Contract
    /// @param name_ follows the name for the collection (ERC721A)
    /// @param symbol_ follows the symbol for the collection (ERC721A)
    /// @param maxBatchSize_ follows the maximun quantity of tokens minted at a time (ERC721A)
    /// @param collectionSize_ follows the size of the collection (ERC721A)
    /// @param nonHolderReferrerRoyalty_ will set the value for NON_HOLFER_REFERRER_ROYALTY variable
    /// @param holderReferrerRoyalty_ will set the value for HOLDER_REFERRER_ROYALTY variable
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxBatchSize_,
        uint256 collectionSize_,
        uint nonHolderReferrerRoyalty_,
        uint holderReferrerRoyalty_
    ) ERC721A(name_, symbol_, maxBatchSize_, collectionSize_) {
        NON_HOLDER_REFERRER_ROYALTY = nonHolderReferrerRoyalty_;
        HOLDER_REFERRER_ROYALTY = holderReferrerRoyalty_;
    }

    /// @notice Internal function to send the referrer royalty based on the balance of the referrer
    /// @param referrer defines the wallet that will be rewarded
    function _sendReferrerRoyalty(address referrer) internal {
        referrerMapping[totalSupply()] = referrer;
        if (balanceOf(referrer) > 0) {
            payable(referrer).transfer(msg.value*HOLDER_REFERRER_ROYALTY/100);
        } else {
            payable(referrer).transfer(msg.value*NON_HOLDER_REFERRER_ROYALTY/100);
        }
    }

    /// @notice Function to get the referrer wallet of a token
    /// @param tokenId the token id to get the referrer
    /// @return referrerAddress in address format
    function getTokenReferrer(uint tokenId) external view returns (address referrerAddress) {       
        int loopLimit = int(tokenId)-int(maxBatchSize);
        address tokenHolder = ownerOf(tokenId);
        for (int i=int(tokenId); i>loopLimit; i--) {
            if (tokenHolder != ownerOf(uint(i))) {
                return referrerMapping[uint(i)+1];
            }
            if (i==0 || (loopLimit>=0&&i==loopLimit+1) || referrerMapping[uint(i)] != address(0)) {
                return referrerMapping[uint(i)];
            }
        }
    }

}