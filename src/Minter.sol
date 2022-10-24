// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "erc721a/contracts/ERC721A.sol";

// this contract mints an NFT at Lottery creation

contract Minter is ERC721A {
    constructor() ERC721A("Ovora Orb", "OVRA") {
         _mint(msg.sender, 1);
    }

    function _baseURI() override internal view virtual returns (string memory) {
        return "bafkreidsqqxpctqwkofshkktufkh7ohnfdxvrrppmgv5r2yoell7v6m7by/";
    }
}