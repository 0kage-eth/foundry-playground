//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/BasicERC4626Deposit.sol";
import "src/MockERC20.sol";

contract InvariantBasicERC4626DepositDirect is Test{

    BasicERC4626Deposit public vault;
    MockERC20 public token;

    function setUp() external {
        token = new MockERC20("ZeroKage", "0Kage", 18);
        vault = new BasicERC4626Deposit(address(token), "zkVault", "zkV", 18);
    }

    function invariant_UserSharesLessThanTotalSupply() external {
        assertGe(vault.totalSupply(), vault.balanceOf(address(this))); //direct calling of an invariant in this case leads to reverts
    }
        // first we need to ensure that this address has enough NMock Tokens and then we need to give approval to the vault to use tokens for deposiut

}