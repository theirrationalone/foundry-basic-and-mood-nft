// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MoodNft is ERC721, Ownable {
    error MoodNft__TokenUriNotFound();
    error MoodNft__OnlyOwnerCanFilpMood();

    enum Mood {
        HAPPY,
        SAD
    }

    string private i_sadSvgImageUri;
    string private i_happySvgImageUri;

    uint256 private s_tokenCounter;
    mapping(uint256 tokenId => Mood mood) private s_moodUris;

    event NFTCreated(uint256 indexed tokenId);
    event MoodFlipped(uint256 indexed currentMood);

    constructor(string memory _sadSvgImageUri, string memory _happySvgImageUri) ERC721("MOOD NFT", "MDN") {
        i_sadSvgImageUri = _sadSvgImageUri;
        i_happySvgImageUri = _happySvgImageUri;
        s_tokenCounter = 0;
    }

    function mintNft() external {
        uint256 currentToken = s_tokenCounter;
        _safeMint(msg.sender, currentToken);
        s_tokenCounter++;
        emit NFTCreated(currentToken);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 _tokenId) external {
        if (!_isApprovedOrOwner(msg.sender, _tokenId)) {
            revert MoodNft__OnlyOwnerCanFilpMood();
        }

        s_moodUris[_tokenId] == Mood.HAPPY ? s_moodUris[_tokenId] = Mood.SAD : s_moodUris[_tokenId] = Mood.HAPPY;

        emit MoodFlipped(uint256(s_moodUris[_tokenId]));
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        if (!_exists(_tokenId)) {
            revert MoodNft__TokenUriNotFound();
        }

        string memory imageUri = i_happySvgImageUri;

        if (s_moodUris[_tokenId] == Mood.SAD) {
            imageUri = i_sadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '","description":"An Nft that reflects Mood of the Owner 100% on chain!","image":"',
                            imageUri,
                            '","attributes":[{"trait_type":"Moodiness","value":50}]}'
                        )
                    )
                )
            )
        );
    }

    function getCurrentTokenId() external view returns (uint256) {
        return s_tokenCounter;
    }

    function getSadSvgImageUri() external view returns (string memory) {
        return i_sadSvgImageUri;
    }

    function getHappySvgImageUri() external view returns (string memory) {
        return i_happySvgImageUri;
    }

    function getCurrentMood(uint256 _tokenId) external view returns (uint256) {
        return uint256(s_moodUris[_tokenId]);
    }

    function getBaseUri() external pure returns (string memory) {
        return _baseURI();
    }
}
