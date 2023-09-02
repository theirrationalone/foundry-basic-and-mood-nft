// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft private s_basicNft;

    address MINTER = makeAddr("minter");

    function setUp() external {
        DeployBasicNft deployer = new DeployBasicNft();

        s_basicNft = deployer.run();
    }

    function testTokenCounterIsZeroInitially() public {
        uint256 expectedTokenId = 0;
        uint256 actualTokenId = s_basicNft.getTokenId();

        assertEq(actualTokenId, expectedTokenId);
    }

    function testVerifyNFTTokenNameAndSymbolAreCorrect() public {
        string memory expectedNFTTokenName = "DOGIE";
        string memory expectedSymbol = "DOG";

        string memory actualNFTTokenName = s_basicNft.name();
        string memory actualSymbol = s_basicNft.symbol();

        assertEq(keccak256(abi.encodePacked(actualNFTTokenName)), keccak256(abi.encodePacked(expectedNFTTokenName)));
        assertEq(keccak256(abi.encodePacked(actualSymbol)), keccak256(abi.encodePacked(expectedSymbol)));
    }

    function testMintNftWorksProper() public {
        string memory PUG_IPFS_URI =
            "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

        vm.startPrank(MINTER);
        s_basicNft.mintNft(PUG_IPFS_URI);
        vm.stopPrank();

        string memory storedPugUri = s_basicNft.tokenURI(s_basicNft.getTokenId() - 1);

        assertEq(keccak256(abi.encodePacked(storedPugUri)), keccak256(abi.encodePacked(PUG_IPFS_URI)));
        assert(s_basicNft.getTokenId() > 0);
    }

    function testTokenURIOnInvalidTokenId() public {
        uint256 invalidTokenId = 11;

        vm.expectRevert(BasicNft.BasicNft__TokenUriNotFound.selector);
        s_basicNft.tokenURI(invalidTokenId);
    }

    modifier nftMinted() {
        string memory PUG_IPFS_URI =
            "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

        vm.startPrank(MINTER);
        s_basicNft.mintNft(PUG_IPFS_URI);
        vm.stopPrank();

        _;
    }

    function testTokenUriGivesCorrectUri() public nftMinted {
        string memory actualTokenUri = s_basicNft.tokenURI(s_basicNft.getTokenId() - 1);

        assertEq(
            keccak256(abi.encodePacked(actualTokenUri)),
            keccak256(
                abi.encodePacked(
                    "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json"
                )
            )
        );
    }
}
