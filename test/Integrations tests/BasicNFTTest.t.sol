//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";

contract BasicNFTTest is Test {
    DeployBasicNFT public deployer;
    BasicNFT public basicNft;
    address MINTER;
    string public constant CHIHUAHUA_URI =
        "ipfs://QmZHLVmb7cLipFx2SGyXQk5Ws3chBusZXwmLbaBa3KZZs2";

    function setUp() external {
        deployer = new DeployBasicNFT();
        basicNft = deployer.run();
        MINTER = makeAddr("minter");
        vm.deal(MINTER, 1 ether);
    }

    function testCollectionNameIsCorrect() public {
        string memory name = basicNft.name();

        /*strings are non-primitive types so "==" wouldn't work in 
          comparing them. "abi.encodePacked" converts the string to 
          a dynamic byte and "keccak256" hashes this byte into bytes32,
          a primitive type which can then be compared */
        assert(
            keccak256(abi.encodePacked(name)) ==
                keccak256(abi.encodePacked("Doggos"))
        );
    }

    function testCollectionSymbolIsCorrect() public {
        string memory symbol = basicNft.symbol();
        assert(
            keccak256(abi.encodePacked(symbol)) ==
                keccak256(abi.encodePacked("KAWAII"))
        );
    }

    function testCounterIsSetAfterContractCreation() public {
        uint256 counter = basicNft.getCounter();
        assert(counter == 1);
    }

    function testCounterIncreasesWhenMinting() public {
        //Arrange
        uint256 counter = basicNft.getCounter();
        console.log(counter);
        //Act
        vm.prank(MINTER);
        basicNft.mintNft(CHIHUAHUA_URI);
        uint256 counter2 = basicNft.getCounter();
        //Assert
        assert(counter2 == 2);
    }

    function testTokemUriIsSetWhileMinting() public {
        //Arrange
        uint256 counter = basicNft.getCounter();
        vm.prank(MINTER);
        basicNft.mintNft(CHIHUAHUA_URI);
        //Act
        string memory tokenUri = basicNft.tokenURI(counter);
        //Assert
        assert(
            keccak256(abi.encodePacked(tokenUri)) ==
                keccak256(abi.encodePacked(CHIHUAHUA_URI))
        );
    }

    function testMintFunctionInInteractionsWork() public {}
}
