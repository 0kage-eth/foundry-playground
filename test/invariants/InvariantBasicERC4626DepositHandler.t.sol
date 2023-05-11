//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";

import "./HandlerERC4626Deposit.t.sol";

contract InvariantBasicERC4626DepositHandler is Test{

    HandlerERC7626Deposit private _handler;

    function setUp() external{
        _handler  = new HandlerERC7626Deposit();
    }

    function invariant_TotalSupplyGeHandlerSupply() external {
        assertGe(_handler.vaultTotalSupply(), _handler.handlerBalance());
    }

}