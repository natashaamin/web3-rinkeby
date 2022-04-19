// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // state variable
    // store permanently in contract storage
    uint256 totalWaves;

    /* Use this to generate a random number */
    uint256 private seed;
    
    // // storage array: arrays that stored inside blockchain after excute func
    // uint[] integerArray;
    // bool[] boolArray;
    // address[] addressArray;

    event NewWave(address indexed sender, address indexed receiver, uint256 timestamp, string message, string keyword, uint amount);

    // A struct is basically a custom datatype where we can customize what we want to hold inside it
    struct Wave {
        address sender; // The addressof the user who waved
        address receiver;
        uint256 timestamp; // The timestamp when the user waved
        string message; // The message the user sent
        string keyword;
        uint256 amount;
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Wave[] waves;

    // mapping
    mapping(address => uint256) public lastWavedAt;

    constructor () payable{
        console.log("Yo yo, I am a contract and I am smart");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(address payable receiver, string memory _message, string memory _keyword, uint amount) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30seconds"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);

        /*
         * This is where I actually store the wave data in the array.
         */
        waves.push(Wave(msg.sender, receiver, block.timestamp,_message, _keyword, amount));

        /* Generate a new seed for the next user that sends a wave */
        seed = (block.timestamp + block.difficulty) % 100;

        console.log("Random # generated: %d", seed);

        /* Give a 50% chance that user wins the prize */
        if(seed <= 50) {
            console.log("%s won!", msg.sender);

            /* The same code we had before to send the prize */
            uint256 prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success,"FAiled to withdraw money from contract");

        }
    }

    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }






    

    // // memory array: not stored into blockchain after calling the func
    // // can only declare within a func

    // /** Visible external */
    // function functionExternal(uint[] calldata myArg) external pure returns(uint[] memory) {
    //     uint[] memory newArray = new uint[](10);
    //     newArray[0] = 1;
    //     return newArray;
    // }


    // /** Visible public */
    // function functionPublic(uint[] memory myArg) public pure returns(uint[] memory) {
    //     uint[] memory newArray = new uint[](10);
    //     newArray[0] = 1;
    //     return newArray;
    // }

    // function manipulateArrayMap() external {
    //     addressMap[msg.sender].push('ss');             //assign a value; 
    //     addressMap[msg.sender][0];                  //access the element in the map array
    //     delete addressMap[msg.sender][0];           //delete the element in the index 0 of the map array
    // }

}