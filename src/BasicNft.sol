// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    error BasicNft__TokenUriNotFound();

    uint256 private s_tokenCounter;

    mapping(uint256 tokenId => string uri) private s_tokenUris;

    constructor() ERC721("DOGIE", "DOG") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory _tokenUri) external {
        s_tokenUris[s_tokenCounter] = _tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        if (!_exists(_tokenId)) {
            revert BasicNft__TokenUriNotFound();
        }

        return s_tokenUris[_tokenId];
    }

    function getTokenId() external view returns (uint256) {
        return s_tokenCounter;
    }
}
