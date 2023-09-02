// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Script} from "forge-std/Script.sol";

import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNft is Script {
    uint256 private constant ANVIL_DEFAULT_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function run() external returns (MoodNft) {
        uint256 deployerKey;
        if (block.chainid == 31337) {
            deployerKey = ANVIL_DEFAULT_PRIVATE_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        string memory happy_svg = vm.readFile("images/svgs/happy_svg.svg");
        string memory sad_svg = vm.readFile("images/svgs/sad_svg.svg");

        vm.startBroadcast(deployerKey);
        MoodNft moodNft = new MoodNft(convertSvgToUri(sad_svg), convertSvgToUri(happy_svg));
        vm.stopBroadcast();

        return moodNft;
    }

    function convertSvgToUri(string memory _svg) public pure returns (string memory) {
        string memory svgPrefix = "data:image/svg+xml;base64,";
        string memory svgUri = Base64.encode(bytes(string(abi.encodePacked(_svg))));

        return string(abi.encodePacked(svgPrefix, svgUri));
    }
}
