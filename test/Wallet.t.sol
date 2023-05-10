//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/Wallet.sol";

contract TestWallet is Test {

    Wallet public wallet;
    address public alice;
    address public bob;
    receive() external payable {}
    function setUp() external{
        wallet = new Wallet();
        vm.deal(address(wallet), 10 ether);
        alice = address(952);
        bob = address(999);
    }

    function testWalletBalance() external{
        assertEq(address(wallet).balance, 10 ether);
    }

    function testOnlyOwnerCanWithdraw() external{
         vm.prank(alice);
         vm.expectRevert("only owner can withdraw");
         wallet.withdraw(address(wallet).balance);   
    }

    function testOnlyOwnerCanSetNewOwner() external{
        vm.prank(alice);
        vm.expectRevert("only owner can set new owner");
        wallet.setOwner(alice);
    }

    function testSetOwner() external{
        wallet.setOwner(alice);
        assertEq(wallet.owner(), alice);
    }

    function testSetOwnerAgain() external{
        wallet.setOwner(alice);
        vm.prank(alice);
        wallet.setOwner(bob);

        assertEq(wallet.owner(), bob);

    }

    function testFailNotOwner() external{
        vm.prank(alice);
        wallet.setOwner(alice);

    }

    function testWithdrawBalance() external{
        assertEq(address(wallet).balance, 10 ether);
        assertEq(wallet.owner(), address(this));
        uint256 balanceBefore = address(this).balance;
        wallet.withdraw(0.5 ether);
        uint256 balanceAfter = address(this).balance;
        assertEq(balanceBefore + 0.5 ether, balanceAfter);
    }
}