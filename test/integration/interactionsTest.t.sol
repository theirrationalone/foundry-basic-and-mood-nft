// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {BasicNft} from "../../src/BasicNft.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {MintBasicNft, MintMoodNft, FlipMood} from "../../script/Interactions.s.sol";

contract BasicNftTest is Test {
    BasicNft private s_basicNft;
    MoodNft private s_moodNft;

    string private constant PUG_IPFS_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        DeployBasicNft deployer = new DeployBasicNft();
        DeployMoodNft mood_deployer = new DeployMoodNft();

        s_basicNft = deployer.run();
        s_moodNft = mood_deployer.run();
    }

    function testMintBasicNftRunFunctionWorksCorrectly() public {
        MintBasicNft mintBasicNft = new MintBasicNft();
        mintBasicNft.run();
    }

    function testMintBasicNftWorksCorrectly() public {
        MintBasicNft mintBasicNft = new MintBasicNft();

        vm.chainId(31337);
        mintBasicNft.mintBasicNft(address(s_basicNft), PUG_IPFS_URI);

        vm.chainId(11155111);
        mintBasicNft.mintBasicNft(address(s_basicNft), PUG_IPFS_URI);

        assert(s_basicNft.getTokenId() > 0);
        assertEq(keccak256(abi.encodePacked(s_basicNft.tokenURI(0))), keccak256(abi.encodePacked(PUG_IPFS_URI)));
    }

    function testMintMoodNftRunFunctionWorksCorrectly() public {
        MintMoodNft mintMoodNft = new MintMoodNft();
        mintMoodNft.run();
    }

    function testMintMoodNftWorksCorrectly() public {
        MintMoodNft mintMoodNft = new MintMoodNft();

        vm.chainId(31337);
        mintMoodNft.mintMoodNft(address(s_moodNft));

        vm.chainId(11155111);
        mintMoodNft.mintMoodNft(address(s_moodNft));

        assert(s_moodNft.getCurrentTokenId() > 0);
    }

    function testFlipMoodWorksCorrectly() public {
        MintMoodNft mintMoodNft = new MintMoodNft();
        FlipMood flipMood = new FlipMood();

        vm.chainId(31337);
        mintMoodNft.mintMoodNft(address(s_moodNft));
        uint256 mintedTokenId_1 = (s_moodNft.getCurrentTokenId() - 1);
        flipMood.flipMood(address(s_moodNft), mintedTokenId_1);

        vm.chainId(11155111);
        mintMoodNft.mintMoodNft(address(s_moodNft));
        uint256 mintedTokenId_2 = (s_moodNft.getCurrentTokenId() - 1);
        flipMood.flipMood(address(s_moodNft), mintedTokenId_2);
    }

    function testMintingAndFlipingWorksInIntegration() public {
        MintMoodNft mintMoodNft = new MintMoodNft();
        mintMoodNft.mintMoodNft(address(s_moodNft));

        uint256 mintedTokenId = (s_moodNft.getCurrentTokenId() - 1);

        FlipMood flipMood = new FlipMood();
        flipMood.flipMood(address(s_moodNft), mintedTokenId);
    }
}
