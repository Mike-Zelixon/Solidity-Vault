// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyVault.sol";

contract MyVaultTest is Test {

    MyVault vault;

    receive() external payable{}

    function setUp() public {
        vault = new MyVault();
    }

    function test_deposit_works() public {
        vault.deposit{value: 1 ether}();
        assertEq(vault.balanceCheck(), 1 ether);
}

    function test_deposit_zero_reverts() public {
        vm.expectRevert();
        vault.deposit{value: 0 ether}();
}

    function test_withdaw_works() public {
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 1 ether}();
        vault.withdraw(1 ether);
        assertEq(vault.balanceCheck(), 0 ether);
    }

    function test_withdraw_zero_reverts() public {
        vm.expectRevert();
        vault.withdraw(0 ether);
    }

    function test_withdraw_insufficient_balance_reverts() public {
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 1 ether}();
        vm.expectRevert();
        vault.withdraw(2 ether);
    }

    function test_withdraw_updates_eth_balance() public {
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 2 ether}();
        uint256 balanceBefore = address(this).balance;
        vault.withdraw(1 ether);
        assertEq(vault.balanceCheck(), 1 ether);
        assertEq(address(this).balance, balanceBefore + 1 ether);
    }
}