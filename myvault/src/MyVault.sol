// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyVault {

    mapping (address => uint256) private balances;

    event Deposited(uint256 amount, address indexed depositor);
    event Withdrawn(uint256 amount, address indexed withdrawal);

    error ZeroDeposit();
    error ZeroWithdrawal();
    error InsufficientWD(); 

    function deposit() external payable {

        if (msg.value == 0) revert ZeroDeposit();
        balances[msg.sender] += msg.value; 

        emit Deposited(msg.value, msg.sender);
    }

    function withdraw(uint256 amount) public {

        if (amount == 0) revert ZeroWithdrawal();
        if (balances[msg.sender] < amount) revert InsufficientWD();

        balances[msg.sender] -= amount;

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "WD Failed");

        emit Withdrawn(amount, msg.sender);

    }

    function balanceCheck() public view returns (uint256) {
        return balances[msg.sender];
    }

}