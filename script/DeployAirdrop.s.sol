//SDPX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "../lib/forge-std/src/Script.sol";
import {AirdropContract} from "../src/AirdropContract.sol";
import {IO10} from "../src/IO10.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployAirdrop is Script {
    IO10 private io10;
    AirdropContract private airdropcontract;
    uint256 private constant TOTALSUPPLY = 10000000000 * 1e18;

    bytes32 private constant MERKLEROOT =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    function run() public returns (AirdropContract) {
        vm.startBroadcast();
        io10 = new IO10(TOTALSUPPLY);
        airdropcontract = new AirdropContract(address(io10), MERKLEROOT);
        io10.mint(address(airdropcontract), TOTALSUPPLY);
        vm.stopBroadcast();
        return airdropcontract;
    }

    function getIO10address() public view returns (address) {
        return address(io10);
    }
}
