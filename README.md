# Solidity-Vault
A simple vault for withdrawing and depositing ETH with a full test suite in forge

# Overview 
A simple solidity contract designed to act as a vault for depositing and withdrawing ETH. 

The vault has three functions: deposit, withdraw, and a balance checker. 

The project includes a test suite in foundry for all three functions. 

# Functions 
## Deposit 
This allows any address to deposit to the contract. 
Checks for irregularities in case of a zero ETH deposit. 

## Withdraw 
Allows for any address that has deposited ETH into the contract to withdraw. 

## Balance Checker 
Allows for any address to check the balance tied to it within the contract.  

# Security Decisions
**Checks-Effects-Interactions pattern** — the withdraw function updates 
the caller's balance before sending ETH to prevent reentrancy attacks. 
If ETH were sent first, a malicious contract could re-enter withdraw 
before the balance updates and drain the vault.

**`.call` over `.transfer`** — ETH is sent using `.call` instead of 
`.transfer` because `transfer` has a hardcoded 2300 gas limit that can 
fail with smart contract recipients.

**Custom errors** — custom errors are used instead of require strings 
for gas efficiency. They cost less to deploy and revert with less gas.
 
