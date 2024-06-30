//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft_TokenDoesNotExist();
    error MoodNft_NotOwner();

    string private s_sadImageUri;
    string private s_happyImageUri;
    uint256 private s_tokenCounter;
    mapping(uint256 => Mood) private s_tokenToMood;
    mapping(uint256 => address) private s_tokenToOwner;

    enum Mood {
        HAPPY,
        SAD
    }

    modifier _tokenMustExist(uint256 tokenId) {
        if (s_tokenToOwner[tokenId] == address(0)) {
            revert MoodNft_TokenDoesNotExist();
        }
        _;
    }

    //ImageUri must be converted to base64 before passing
    constructor(
        string memory sadImageUri,
        string memory happyImageUri
    ) ERC721("MoodNft", "MN") {
        s_sadImageUri = sadImageUri;
        s_happyImageUri = happyImageUri;
        s_tokenCounter = 0;
    }

    function mintNft() public returns (string memory) {
        uint256 counter = s_tokenCounter;
        s_tokenCounter++;
        s_tokenToMood[counter] = Mood.HAPPY;
        s_tokenToOwner[counter] = msg.sender;
        _safeMint(msg.sender, counter);
        return "Mood Nft Minted";
    }

    function flipMood(uint256 tokenId) public {
        if (
            msg.sender != ownerOf(tokenId) && msg.sender != getApproved(tokenId)
        ) {
            revert MoodNft_NotOwner();
        }

        if (checkMoodIsHappy(tokenId)) {
            s_tokenToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenToMood[tokenId] = Mood.HAPPY;
        }
    }

    function checkMoodIsHappy(
        uint256 tokenId
    ) public view _tokenMustExist(tokenId) returns (bool) {
        return s_tokenToMood[tokenId] == Mood.HAPPY;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override _tokenMustExist(tokenId) returns (string memory) {
        string memory imageUri;
        if (s_tokenToMood[tokenId] == Mood.HAPPY) {
            imageUri = s_happyImageUri;
        } else {
            imageUri = s_sadImageUri;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that changes based on the owners mood", ',
                                ' "image": "',
                                imageUri,
                                '", "attributes": [{"trait_type":"glumliness", value:100}, {"trait_type": "happiness", "value": 0}]}'
                            )
                        )
                    )
                )
            );
    }

    //getter functions
    function getCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
