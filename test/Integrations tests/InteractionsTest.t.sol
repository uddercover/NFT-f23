//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {MintBasicNft} from "../../script/Interactions.s.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MintMoodNft} from "../../script/Interactions.s.sol";
import {FlipMoodNft} from "../../script/Interactions.s.sol";
import {MoodNft} from "../../src/MoodNft.sol";

contract InteractionsTestBasicNft is Test {
    MintBasicNft mintBasicNft;
    BasicNFT basicNft;

    string public constant CHIHUAHUA_URI =
        "ipfs://QmZHLVmb7cLipFx2SGyXQk5Ws3chBusZXwmLbaBa3KZZs2";
    address mostRecentlyDeployedBasicNft =
        DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
    address MINTER = makeAddr("minter");

    function setUp() public {
        DeployBasicNFT basicDeployer = new DeployBasicNFT();
        mintBasicNft = new MintBasicNft();
        basicNft = basicDeployer.run();
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

contract InteractionsTestMoodNft is Test {
    MintMoodNft mintMoodNft;
    MoodNft moodNft;
    FlipMoodNft flipMoodNft;
    address MINTER = makeAddr("minter");

    function setUp() public {
        DeployMoodNft moodDeployer = new DeployMoodNft();
        mintMoodNft = new MintMoodNft();
        flipMoodNft = new FlipMoodNft();
        moodNft = moodDeployer.run();
        vm.deal(MINTER, 1 ether);
    }

    function testMintWorks() public {
        string memory minted = mintMoodNft.mint(address(moodNft));
        assert(
            keccak256(abi.encodePacked(minted)) ==
                keccak256(abi.encodePacked("Mood Nft Minted"))
        );
    }

    function testMoodFlips() public {
        //arrange
        mintMoodNft.mint(address(moodNft));
        //act
        string memory flipped = flipMoodNft.flipMood(address(moodNft), 0);
        //assert
        assert(
            keccak256(abi.encodePacked(flipped)) ==
                keccak256(abi.encodePacked("Mood flipped"))
        );
    }
}
