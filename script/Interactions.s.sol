//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MintBasicNft is Script {
    string public constant CHIHUAHUA_URI =
        "ipfs://QmZHLVmb7cLipFx2SGyXQk5Ws3chBusZXwmLbaBa3KZZs2";

    function run() external returns (string memory) {
        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("BasicNFT", block.chainid);
        string memory minted = mint(mostRecentlyDeployedBasicNft);
        return minted;
    }

    function mint(address basicNft) public returns (string memory) {
        vm.startBroadcast();
        BasicNFT(basicNft).mintNft(CHIHUAHUA_URI);
        vm.stopBroadcast();
        return "Nft Minted";
    }
}

contract MintMoodNft is Script {
    function run() external returns (string memory) {
        address mostRecentlyDeployedMoodNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        string memory minted = mint(mostRecentlyDeployedMoodNft);
        return minted;
    }
    //call the mint function on the contract
    function mint(address moodNft) public returns (string memory) {
        vm.startBroadcast();
        MoodNft(moodNft).mintNft();
        vm.stopBroadcast();
        return "Mood Nft Minted";
    }
}

contract FlipMoodNft is Script {
    function run() external returns (string memory) {
        address mostRecentlyDeployedMoodNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        string memory flipped = flipMood(mostRecentlyDeployedMoodNft, 0);
        return flipped;
    }
    //call the mint function on the contract
    function flipMood(
        address moodNft,
        uint256 tokenId
    ) public returns (string memory) {
        vm.startBroadcast();
        MoodNft(moodNft).flipMood(tokenId);
        vm.stopBroadcast();
        return "Mood flipped";
    }
}
