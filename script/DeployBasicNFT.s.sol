//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract DeployBasicNFT is Script {
    BasicNFT basicNft;
    function run() external returns (BasicNFT) {
        vm.startBroadcast();
        basicNft = new BasicNFT();
        vm.stopBroadcast();
        return basicNft;
    }
}
