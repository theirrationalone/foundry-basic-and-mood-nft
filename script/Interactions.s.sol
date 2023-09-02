// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {BasicNft} from "../src/BasicNft.sol";

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
