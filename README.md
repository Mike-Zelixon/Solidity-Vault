# Solidity Vault

A minimal ETH vault smart contract built in **Solidity** using the **Foundry** framework.

This project allows users to deposit ETH, track balances internally, and withdraw their funds securely. It was built as a learning project focused on understanding core Solidity concepts such as payable functions, mappings, custom errors, events, secure ETH transfers, and Solidity testing with Foundry.

---

## Overview

The vault supports two main actions:

- Deposit ETH into the contract
- Withdraw ETH from your recorded balance

Each user's balance is tracked individually using a mapping from address to deposited amount.

This repository is intended as a small learning project and a foundation for building more advanced Solidity applications.

---

## Features

- Accepts ETH deposits
- Tracks balances per user
- Allows users to withdraw only their own funds
- Rejects zero-value deposits
- Rejects invalid withdrawals
- Rejects withdrawals larger than available balance
- Emits events for deposits and withdrawals
- Uses custom errors for cleaner and more gas-efficient reverts
- Includes automated tests with Foundry

---

## Architecture

The contract uses a simple internal accounting model:

```solidity
mapping(address => uint256) private balances;
```

Each user address maps to the amount of ETH they have deposited in the vault.

---

## Deposit Flow

1. User sends ETH to `deposit()`
2. Contract checks that `msg.value` is greater than zero
3. User balance is increased
4. A `Deposited` event is emitted

---

## Withdraw Flow

1. User calls `withdraw(amount)`
2. Contract checks:
   - `amount` is not zero
   - user has enough balance
3. Contract updates internal state first
4. ETH is sent using `.call()`
5. A `Withdrawn` event is emitted

---

## Security Design

This contract applies several Solidity best practices.

### Checks-Effects-Interactions Pattern

The `withdraw()` function updates internal state before making the external ETH transfer.  
This follows the **Checks-Effects-Interactions** pattern and reduces reentrancy risk.

### Safe ETH Transfers with `.call()`

ETH is sent using:

```solidity
(bool ok, ) = msg.sender.call{value: amount}("");
```

This is preferred over `.transfer()` and `.send()` in modern Solidity because it is more compatible with current gas mechanics.

### Custom Errors

Instead of relying only on revert strings, the contract uses custom errors such as:

- `ZeroETH()`
- `InvalidWithdraw()`
- `InsufficientBalance()`

This improves readability and reduces gas usage.

---

## Contract Functions

### `deposit()`

Accepts ETH and credits the sender's internal balance.

**Requirements**

- `msg.value` must be greater than zero

---

### `withdraw(uint256 amount)`

Withdraws ETH from the caller's balance.

**Requirements**

- `amount` must be greater than zero
- caller must have sufficient balance

---

### `balanceCheck()`

Returns the stored balance of the caller.

---

## Events

The contract emits the following events.

### `Deposited(uint256 amount, address indexed sender)`

Emitted when a user deposits ETH.

### `Withdrawn(uint256 amount, address indexed withdrawal)`

Emitted when a user withdraws ETH.

---

## Tests

The project includes unit tests written with **Foundry**.

Current tests cover:

- successful deposit
- zero deposit revert
- successful withdraw
- zero withdraw revert
- insufficient balance revert
- ETH balance changes after withdrawal

Run tests with:

```bash
forge test
```

For more verbose output:

```bash
forge test -vv
```

---

## Project Structure

```text
myvault/
├── src/
│   └── MyVault.sol
├── test/
│   └── MyVault.t.sol
├── script/
├── foundry.toml
└── README.md
```

---

## Getting Started

### 1. Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Clone the repository

```bash
git clone https://github.com/Mike-Zelixon/Solidity-Vault.git
cd Solidity-Vault/myvault
```

### 3. Build the contract

```bash
forge build
```

### 4. Run the tests

```bash
forge test
```

---

## Example Use Case

This contract is a simple example of ETH custody logic where users can deposit ETH into a contract and later retrieve funds assigned to their address.

It is **not intended for production use** in its current form but serves as a foundation for learning secure Solidity development patterns.

---

## Future Improvements

Possible next steps for expanding this project:

- add exact custom error selector checks in tests
- add fuzz testing
- add invariant testing
- add multi-user interaction tests
- add a reentrancy guard
- improve event naming and indexing
- add NatSpec documentation
- support ownership or admin controls
- add an emergency pause mechanism

---

## Learning Goals

This project was built to practice:

- Solidity syntax and state management
- ETH deposits and withdrawals
- secure contract design patterns
- events and custom errors
- writing and running tests with Foundry
