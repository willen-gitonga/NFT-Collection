// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    /*
       @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
        token will be the concatenation of the `baseURI` and the `tokenId`.
       */
      string _baseTokenURI;
    //_price is price per NFT
      uint256 public _price = 0.01 ether;
    // _paused to pause contract in the event of an emergency 
    bool public _paused;
    
    //max number of NFT to mint 
    uint256 public maxTokenIds = 20;

    //total no of tokenIds minted at current time 
    uint256 public tokenIds;

    //whitelist contract instance 
    IWhitelist whitelist;

    //keeping track if presale has started or not
    bool public presaleStarted;

    //timestamp for when presale ends 
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused,"Contract currently paused");
        _;
    }
   
    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs","CD"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

     /*
     startPresale starts a presale for the whitelisted addresses
    */
    function startPresale() public onlyOwner{
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes
        presaleEnded = block.timestamp + 5 minutes;

    }
    /* @dev presaleMint allows a user to mint one NFT per transaction during the presale.
       */
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < maxTokenIds, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ethere sent is not correct");

        tokenIds +=1;
         //_safeMint is a safer version of the _mint function as it ensures that
        // if the address being minted to is a contract, then it knows how to deal with ERC721 tokens
        // If the address being minted to is not a contract, it works the same way as _mint
        _safeMint(msg.sender, tokenIds);
    }
    
    





}