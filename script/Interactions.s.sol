//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

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
