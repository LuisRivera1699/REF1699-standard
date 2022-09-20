# REF1699 Standard

A standard for referral system implementation in NFT Collections' Smart Contracts.
- Extended contract from ERC721A.
- Reusable royalty function to reward your referrers based on your collection rules

## Overview
**How to extend REF1699**

You have to add the file `REF1699.sol` to your project directory and import it to your Smart Contract. To correctly extend the standard, you will have to set the constructor for the REF1699 standard.

    pragma solidity ^0.8.x;
    
    import "./REF1699.sol";
    
    contract MyCollection is REF1699 {
	    constructor() REF1699(
			"My Collection Name", // Collection Name (ERC721A)
			"MYCOLLECTION", // Collection Symbol (ERC721A)
			20, // Max batch size (ERC721A)
			10000, // Collection size (ERC721A)
			1, // Non holder referrer royalty 
			10 // Holder referrer royalty
		) {}
    }

**How to reward referrers**

To reward your referrers you should use the `_sendReferrerRoyalty()` internal function in any function you want, for example the `mint()` function. NOTE: the function should be a payable function and the `_sendReferrerRoyalty()` should be called before the `_safeMint()` function.

    pragma solidity ^0.8.x;
    
    import "./REF1699.sol";
    
    contract MyCollection is REF1699 {
	    ...
	    function mint(uint quantity_, address referrer) external payable {
		    ... // RESTRICTIONS AND OTHER LOGIC
		    
		    // If referrer isn't 0x0 address send the referrer royalty
		    if (referrer != address(0)) {
			    _sendReferrerRoyalty(referrer);
			}
			_safeMint(msg.sender, _quantity);
			
		    ... // OTHER LOGIC
	    }
	    ...
    }

**How to integrate**

Check out our integration with this Demo in our[`REF1699-minting-site`](https://github.com/LuisRivera1699/REF1699-minting-site) example.

Minting integration

![Referrer minting](https://raw.githubusercontent.com/LuisRivera1699/REF1699-minting-site/main/public/mint.png)

Referrer link generation

![Get referrer link](https://raw.githubusercontent.com/LuisRivera1699/REF1699-minting-site/main/public/refer.png)

## Buy me a cofee ☕☕
**ETH & Polygon Address** : 
0x8306865FAb8dEC66a1d9927d9ffC4298500cF7Ed

**Binance BNB Wallet** : 
0x35b2f646c86d4454c9fb9bc359bbe564c9c81150
## Contact me
**Email**: luisriveradiaz1699@gmail.com
