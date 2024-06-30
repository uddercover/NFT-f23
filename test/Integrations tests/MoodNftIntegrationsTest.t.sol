//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract TestMoodNft is Test {
    MoodNft moodNft;
    DeployMoodNft deployer;
    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
        vm.deal(USER, 1 ether);
    }

    function testMintNftIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        assert(moodNft.getCounter() == 1);
        assert(moodNft.checkMoodIsHappy(0) == true);
    }

    function testFlipMoodFlipsFromHappyToSadIntegration() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        moodNft.flipMood(0);
        vm.stopPrank();
        assert(moodNft.checkMoodIsHappy(0) == false);
    }

    function testFlipMoodFlipsFromSadToHappyIntegration() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        moodNft.flipMood(0);
        assert(moodNft.checkMoodIsHappy(0) == false);
        moodNft.flipMood(0);
        vm.stopPrank();
        assert(moodNft.checkMoodIsHappy(0) == true);
    }

    function testRevertsWorkIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.expectRevert();
        moodNft.checkMoodIsHappy(5);
    }

    function testCorrectTokenUriIsReturnedIntegration() public {
        //arrange,
        string memory expectedTokenUri = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            "MoodNft",
                            '", "description": "An NFT that changes based on the owners mood", ',
                            ' "image": "',
                            "data:xml/svg;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==",
                            '", "attributes": [{"trait_type":"glumliness", value:100}, {"trait_type": "happiness", "value": 0}]}'
                        )
                    )
                )
            )
        );
        //act
        vm.prank(USER);
        moodNft.mintNft();
        string memory actualTokenUri = moodNft.tokenURI(0);
        console.log(actualTokenUri);
        //assert
        assert(
            keccak256(abi.encodePacked(actualTokenUri)) ==
                keccak256(abi.encodePacked(expectedTokenUri))
        );
    }
}
