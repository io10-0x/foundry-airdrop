//SDPX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "../lib/forge-std/src/Script.sol";
import {AirdropContract} from "../src/AirdropContract.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract Interactions is Script {
    error Interactions__InvalidSignature();

    address private claimingaddress =
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 private constant AMOUNT = 25 * 1e18;
    bytes32 private proof1 =
        0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 private proof2 =
        0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] private merkleProof = [proof1, proof2];
    bytes private signedmessage =
        hex"ef8ff0bbb9c789a62659e219050f94ff40028a5b8759c93f581bfcf154451d606105cf059c6441668be2f1e3f9f4690183f1d9f4855569d1c6122f0fd4d4dbd61c";

    function run() public {
        vm.startBroadcast();
        address airdropcontract = DevOpsTools.get_most_recent_deployment(
            "AirdropContract",
            block.chainid
        );
        claimAirdrop(airdropcontract);
        vm.stopBroadcast();
    }

    function claimAirdrop(address interactaddress) private {
        (uint8 v, bytes32 r, bytes32 s) = splitsignature(signedmessage);
        AirdropContract(interactaddress).claim(
            claimingaddress,
            AMOUNT,
            merkleProof,
            r,
            s,
            v
        );
    }

    function splitsignature(
        bytes memory signature
    ) private pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (signature.length != 65) {
            revert Interactions__InvalidSignature();
        }
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        return (v, r, s);
    }
}
