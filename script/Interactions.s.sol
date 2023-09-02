// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MintBasicNft is Script {
    uint256 private constant ANVIL_DEFAULT_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function mintBasicNft(address _basicNftAddress, string memory uri) public {
        uint256 deployerKey;
        if (block.chainid == 31337) {
            deployerKey = ANVIL_DEFAULT_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        BasicNft(_basicNftAddress).mintNft(uri);
        vm.stopBroadcast();
    }

    function mintBasicNftUsingConfig(address _basicNftAddress) internal {
        string memory PUG_IPFS_URI =
            "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
        mintBasicNft(_basicNftAddress, PUG_IPFS_URI);
    }

    function run() external {
        address recentBasicNft = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);

        mintBasicNftUsingConfig(recentBasicNft);
    }
}

contract MintMoodNft is Script {
    uint256 private constant ANVIL_DEFAULT_PRIVATE_KEY =
        0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

    function mintMoodNft(address _recentMoodNft) public {
        uint256 deployerKey;
        if (block.chainid == 31337) {
            deployerKey = ANVIL_DEFAULT_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        MoodNft(_recentMoodNft).mintNft();
        vm.stopBroadcast();
    }

    function mintMoodNftUsingConfig(address _recentMoodNft) internal {
        mintMoodNft(_recentMoodNft);
    }

    function run() external {
        address recentMoodNft = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);

        mintMoodNftUsingConfig(recentMoodNft);
    }
}

contract FlipMood is Script {
    uint256 private constant ANVIL_DEFAULT_PRIVATE_KEY =
        0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;

    function flipMood(address _recentMoodNft, uint256 _mintedTokenId) public {
        uint256 deployerKey;
        if (block.chainid == 31337) {
            deployerKey = ANVIL_DEFAULT_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        MoodNft(_recentMoodNft).flipMood(_mintedTokenId);
        vm.stopBroadcast();
    }

    function flipMoodUsingConfig(address _recentMoodNft) internal {
        vm.startBroadcast(ANVIL_DEFAULT_PRIVATE_KEY);
        MoodNft(_recentMoodNft).mintNft();
        vm.stopBroadcast();

        uint256 mintedTokenId = (MoodNft(_recentMoodNft).getCurrentTokenId() - 1);
        flipMood(_recentMoodNft, mintedTokenId);
    }

    function run() external {
        address recentMoodNft = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);

        flipMoodUsingConfig(recentMoodNft);
    }
}
