//SDPX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployAirdrop} from "script/DeployAirdrop.s.sol";
import {AirdropContract} from "src/AirdropContract.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {IO10} from "src/IO10.sol";

contract AirdropContractUnitTests is Test, ZkSyncChainChecker {
    DeployAirdrop private deployAirdropContract;
    AirdropContract private airdropContract;
    uint256 private constant AMOUNT = 25 * 1e18;
    bytes32 private proof1 =
        0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 private proof2 =
        0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] private merkleProof = [proof1, proof2];
    address private IO10address;
    IO10 private io10;
    bytes32 private constant MERKLEROOT =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 private constant TOTALSUPPLY = 10000000000 * 1e18;
    address user1 = vm.addr(1);

    function setUp() public {
        if (isZkSyncChain()) {
            io10 = new IO10(TOTALSUPPLY);
            airdropContract = new AirdropContract(address(io10), MERKLEROOT);
            io10.mint(address(airdropContract), TOTALSUPPLY);
        }
        deployAirdropContract = new DeployAirdrop();
        airdropContract = deployAirdropContract.run();
        IO10address = deployAirdropContract.getIO10address();
    }

    function testusercanclaimairdrop() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        bytes32 signaturemessage = airdropContract.getEIP712SignatureMessage(
            0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            AMOUNT
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80,
            signaturemessage
        );
        vm.stopPrank();
        vm.startPrank(user1);
        airdropContract.claim(
            0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            AMOUNT,
            merkleProof,
            r,
            s,
            v
        );
        vm.stopPrank();
        assertEq(
            AMOUNT,
            IERC20(IO10address).balanceOf(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            )
        );
    }
}
