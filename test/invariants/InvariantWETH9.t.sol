//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "./Handlers/WethHandler.t.sol";
import "src/WETH9.sol";
contract InvariantWeth9 is Test {
    WETH9 private weth;
    WethHandler private handler;

    function setUp() external {
        weth = new WETH9();
        handler = new WethHandler(weth);

        targetContract(address(handler)); // includes the handler contract in target
    }


    function invariant_supply() external {
        assertEq(address(weth).balance, handler.weth().totalSupply());
    }

    function invariant_balance() external {
        assertEq(address(weth).balance, handler.ghost_depositSum() - handler.ghost_withdrawSum());
    }
}