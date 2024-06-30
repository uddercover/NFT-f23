//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721 {
    uint256 private s_counter;
    mapping(uint256 tokenId => string) private s_tokenToUri;
    constructor() ERC721("Doggos", "KAWAII") {
        s_counter = 1;
    }

    function mintNft(string memory tokenUri) public {
        uint256 counter = s_counter;
        s_counter++;
        s_tokenToUri[counter] = tokenUri;
        _safeMint(msg.sender, counter);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenToUri[tokenId];
    }

    //Getters
    function getCounter() public view returns (uint256) {
        return s_counter;
    }
}
