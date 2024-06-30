//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {MintBasicNft} from "../../script/Interactions.s.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";

contract InteractionsTest is Test {
    MintBasicNft mintBasicNft;
    BasicNFT basicNft;
    string public constant CHIHUAHUA_URI =
        "ipfs://QmZHLVmb7cLipFx2SGyXQk5Ws3chBusZXwmLbaBa3KZZs2";
    address mostRecentlyDeployedBasicNft =
        DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
    address MINTER = makeAddr("minter");

    function setUp() public {
        vm.startBroadcast();
        basicNft = new BasicNFT();
        mintBasicNft = new MintBasicNft();
        vm.stopBroadcast();
        vm.deal(MINTER, 1 ether);
    }

    function testMintWorks() public {
        mintBasicNft.mint(address(basicNft));
        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(1))) ==
                keccak256(abi.encodePacked(CHIHUAHUA_URI))
        );
    }
}
