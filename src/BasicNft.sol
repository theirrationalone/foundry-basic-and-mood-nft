// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    error BasicNft__TokenUriNotFound();

    uint256 private s_tokenCounter;

    mapping(uint256 tokenId => string uri) private s_tokenUris;

    // string private constant PUG_IPFS_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    constructor() ERC721("DOGIE", "DOG") {}

    function mintNft(string memory _tokenUri) public {
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

    function getTokenId() public view returns (uint256) {
        return s_tokenCounter;
    }
}
