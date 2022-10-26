// SPDX-License-Identifier: MIT

// theoretically, you can predict the random number with this contract
// because the pseudo-random number is public available data
// winner get the NFT
// the owner of the contrcat gets the funds

import "./Minter.sol";

pragma solidity ^0.8.11;

contract Lottery is Minter {
    address payable public owner;
    address payable[] public players;
    uint public lotteryId;
    // maps the ID to the lottery address
    mapping (uint => address payable) public lotteryHistory;

    // first lottery has an ID of 1
    constructor() {
        owner = payable(msg.sender);
        lotteryId = 1;
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    // gets the balance of the lottery contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // must pay > .01 ether to enter raffle
    function enter() public payable {
        require(msg.value > .01 ether);

        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // transfer the winner the NFT and transfer the contract funds to the owner
    function pickWinner() public payable onlyowner {
        // gives us a random number between zero and the length of
        // array - 1
        uint index = getRandomNumber() % players.length;
        address winner = players[index]; 

        // transfer the NFT balance from the owner to the winner
        ERC721A.safeTransferFrom(owner, winner, 0);

        // transfers the Contract ERC20 balance to the owner
        owner.transfer(address(this).balance);

        // lottery ID is set to the address of the winner
        lotteryHistory[lotteryId] = players[index];
        // increases the lottery ID
        lotteryId++;
        
        // reset the state of the contract
        players = new address payable[](0);
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
    }
}