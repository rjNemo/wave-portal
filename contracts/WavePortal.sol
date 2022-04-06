// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        seed = newSeed();
    }

    uint256 totalWaves;
    mapping(address => uint256) peopleToWaves;
    mapping(address => uint256) lastWavedAt;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes <= block.timestamp,
            "Wait 15 minutes to wave again"
        );
        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves++;
        peopleToWaves[msg.sender]++;
        console.log("%s has waved with message: %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = newSeed();

        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.001 ether;
            require(prizeAmount <= address(this).balance);
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw from the contract"); // mark the transaction as an error if it failed
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d waves!", totalWaves);
        return totalWaves;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function newSeed() private view returns (uint256) {
        return (block.timestamp + block.difficulty) % 100;
    }
}
