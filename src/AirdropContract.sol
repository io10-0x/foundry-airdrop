//SDPX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Script, console} from "../lib/forge-std/src/Script.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

using SafeERC20 for IERC20;

contract AirdropContract is EIP712 {
    error AirdropContract__Invalidproof();
    error AirdropContract__AlreadyClaimed();
    error AirdropContract__InvalidSignature();

    event AirdropClaimed(address indexed user, uint256 indexed amount);

    address private immutable i_tokenToAirdrop;
    bytes32 private immutable i_merkleroot;
    bytes32 private leaf;

    mapping(address => bool) public claimed;
    struct Message {
        address account;
        uint256 amount;
    }
    Message public message;
    bytes32 typehash =
        keccak256(abi.encode("Message(address account,uint256 amount)"));

    constructor(
        address tokentoairdrop,
        bytes32 merkleRoot
    ) EIP712("AirdropContract", "1.0.0") {
        i_tokenToAirdrop = tokentoairdrop;
        i_merkleroot = merkleRoot;
    }

    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) external {
        if (claimed[account]) {
            revert AirdropContract__AlreadyClaimed();
        }
        message = Message(account, amount);
        bytes32 signaturemessage = getEIP712SignatureMessage(
            message.account,
            message.amount
        );
        if (!verifysignature(account, signaturemessage, r, s, v)) {
            revert AirdropContract__InvalidSignature();
        }
        leaf = keccak256(
            abi.encodePacked(keccak256(abi.encode(account, amount)))
        );
        bool proof = MerkleProof.verify(merkleProof, i_merkleroot, leaf);
        if (!proof) {
            revert AirdropContract__Invalidproof();
        }
        claimed[account] = true;
        emit AirdropClaimed(account, amount);

        IERC20(i_tokenToAirdrop).safeTransfer(account, amount);
    }

    function getEIP712SignatureMessage(
        address account,
        uint256 amount
    ) public view returns (bytes32) {
        bytes32 digest = _hashTypedDataV4(
            keccak256(abi.encode(typehash, account, amount))
        );
        return digest;
    }

    function verifysignature(
        address account,
        bytes32 signaturemessage,
        bytes32 r,
        bytes32 s,
        uint8 v
    ) internal pure returns (bool) {
        (address signer, , ) = ECDSA.tryRecover(signaturemessage, v, r, s);
        return signer == account;
    }

    function getleaf() external view returns (bytes32) {
        return leaf;
    }
}
