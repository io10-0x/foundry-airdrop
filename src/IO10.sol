//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract IO10 is ERC20, Ownable {
    error Decentralisedstablecoin__cannotsendtozeroaddress();
    error Decentralisedstablecoin__cannotmintzeroamount();

    constructor(
        uint256 initialSupply
    ) ERC20("IO10", "10") Ownable(msg.sender) {}

    function mint(address account, uint256 amount) public onlyOwner {
        if (account == address(0)) {
            revert Decentralisedstablecoin__cannotsendtozeroaddress();
        }
        if (amount <= 0) {
            revert Decentralisedstablecoin__cannotmintzeroamount();
        }
        _mint(account, amount);
    }
}
