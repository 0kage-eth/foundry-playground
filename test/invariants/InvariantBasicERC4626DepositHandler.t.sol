//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";

import "./handlers/HandlerERC4626Deposit.t.sol";

contract InvariantBasicERC4626DepositHandler is Test{

    HandlerERC7626Deposit private _handler;

    function setUp() external{
        _handler  = new HandlerERC7626Deposit();

        // add the handler selectors to the fuzzing targets
        bytes4[] memory selectors = new bytes4[](2);

        selectors[0] = HandlerERC7626Deposit.depositHandler.selector;
        selectors[1] = HandlerERC7626Deposit.withdrawHandler.selector;

        targetSelector(FuzzSelector({addr: address(_handler), selectors: selectors}));
        targetContract(address(_handler));
    }

    function invariant_TotalSupplyGeHandlerSupply() external {
        assertGe(_handler.vaultTotalSupply(), _handler.handlerBalance());
    }

}