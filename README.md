# Airdrop and Signatures, Merkle Trees, and Proofs: README

## Overview

This repository explores the implementation of an airdrop system using ERC20 tokens and Merkle Trees. It introduces advanced concepts such as cryptographic signatures, EIP standards, and proof mechanisms to optimize gas usage and ensure security.

Key topics include:

- Airdrop contract design.
- Merkle proofs for efficient verification.
- Cryptographic signature verification (EIP-191 and EIP-712).
- Implementation of blob transactions and protodanksharding.

---

## Features

- **Efficient Airdrop System:**
  - Uses Merkle Trees to optimize gas costs.
  - Eliminates the need for looping through large datasets.
- **Signature Verification:**
  - Prevents unauthorized claims using EIP-712.
  - Incorporates v, r, and s components of ECDSA signatures.
- **Blob Transactions:**
  - Implements temporary storage to reduce on-chain data storage costs.
- **Modular Code Design:**
  - Built with OpenZeppelin libraries for cryptographic and ERC20 token functionalities.

---

## Contracts

### 1. `ERC20Token.sol`

A standard ERC20 token contract used for airdropping tokens to eligible addresses.

#### Key Points

- **Inherits From:**
  - `IERC20` (OpenZeppelin)
  - `SafeERC20` (OpenZeppelin)
- **Functionality:**
  - Token minting and transfer.
  - Compatibility with `AirdropContract.sol`.

---

### 2. `AirdropContract.sol`

The core contract managing the airdrop process.

#### Key Points

- **Constructor:**
  - Accepts the ERC20 token address and the root hash of the Merkle Tree.
- **Merkle Proof Verification:**
  - Uses OpenZeppelin’s `MerkleProof.sol` for efficient verification.
- **Signature Validation:**
  - Implements EIP-712 to validate that claimers are authorized.
- **Security Features:**
  - Protects against signature malleability.
  - Prevents double claims with a `claimed` mapping.

#### Key Functions

- `claim`: Allows users to claim their airdropped tokens after proving eligibility with Merkle Proofs and a valid signature.
- `getEIP712SignatureMessage`: Generates the structured EIP-712 signature message.
- `verifysignature`: Confirms the validity of the claim signature using v, r, and s values.

---

### 3. `GenerateMerkleTree.sol`

A utility script for creating Merkle Trees.

#### Key Points

- **Input Data:**
  - Addresses and their respective airdrop amounts.
- **Output:**
  - A JSON file containing the Merkle Tree with proofs, leaf nodes, and the root hash.

---

## Testing

### Unit Testing

- Verifies functionality of:
  - Merkle Proof validation.
  - EIP-712 signature verification.
  - Token claiming process.

### Interaction Testing

- Demonstrates how to:
  - Generate and sign structured messages using `cast wallet sign`.
  - Claim tokens using signed messages and proofs.

### Invariant Testing

- **Double Claims:** Ensures users cannot claim tokens more than once.
- **Signature Validation:** Confirms that only authorized signatures are valid.

---

## Usage

1. **Clone the Repository:**

   ```bash
   git clone <repository-url>
   cd foundry-airdrop
   forge install

   ```

2. **Compile Contracts:**

   ```bash
   forge build

   ```

3. **Deploy Contracts:**

   ```bash
   forge script ./script/DeployAirdrop.s.sol:DeployAirdrop
   with appropriate rpc url, account and other required arguments.

   ```

4. **Run Tests:**

   ```bash
   forge test -vvvv

   ```

5. **Generate Merkle Tree:**
   Use the GenerateInput.s.sol and MakeMerkle.s.sol scripts to create the input.json and output.json files for Merkle Tree generation.

6. **Claim Tokens:**
   Use the interaction script Interactions.s.sol to claim tokens using valid proofs and signatures.

# Tools and Libraries

- **Foundry**: For smart contract development and testing.
- **OpenZeppelin Libraries**: Cryptographic and ERC20 utilities.
- **Murky**: Merkle Tree generation library.
- **Etherscan & Cast**: For transaction and signature verification.

---

## Signature Standards and Security

### EIP-191

- Defines the format for transferable signatures.
- Introduces the `0x19` prefix to distinguish signatures from transactions.
- Supports structured and personal messages.

### EIP-712

- Enhances readability by allowing structured data for signatures.
- Avoids replay attacks using a domain separator.
- Replaces `eth_sign` with a more secure and user-friendly signing process.

### Signature Components (`v`, `r`, `s`)

- **`v`**: Indicates the recovery parameter (even/odd y-coordinate).
- **`r`**: Derived from the x-coordinate of the elliptic curve point.
- **`s`**: Represents the signature's proof of validity.

---

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
