//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadImageUri = svgToImageUri(
            vm.readFile("./img/MoodImages/sadSvg.svg")
        );
        string memory happyImageUri = svgToImageUri(
            vm.readFile("./img/MoodImages/happySvg.svg")
        );
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(sadImageUri, happyImageUri);
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseUrl = "data:xml/svg;base64,";
        string memory svgEncoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseUrl, svgEncoded));
    }
}
