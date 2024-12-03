//SDPX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script, console} from "../lib/forge-std/src/Script.sol";

contract SplitSignature is Script {
    error SplitSignature__InvalidSignature();

    function run() public {
        bytes
            memory signedmessage = hex"2eb1fdf848095269be40e326e27774bc6d6160b5a62c9b777e24a07684ffd554559ee054d5f10f1849e83b980b946bb778bed68656496655bf769dee0c9f5ef41c";

        (uint8 v, bytes32 r, bytes32 s) = splitsignature(signedmessage);
        console.log(v);
        console.logBytes32(r);
        console.logBytes32(s);
    }

    function splitsignature(
        bytes memory signature
    ) private pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (signature.length != 65) {
            revert SplitSignature__InvalidSignature();
        }
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        return (v, r, s);
    }
}
