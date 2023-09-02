// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../../script/Interactions.s.sol";

contract BasicNftTest is Test {
    BasicNft private s_basicNft;

    string private constant PUG_IPFS_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        DeployBasicNft deployer = new DeployBasicNft();

        s_basicNft = deployer.run();
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
}
