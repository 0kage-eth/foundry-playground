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

        bytes4[] memory selectors = new bytes4[](3);

        selectors[0] = handler.deposit.selector;
        selectors[1] = handler.withdraw.selector;
        selectors[2] = handler.sendDirectEth.selector;

        targetSelector(FuzzSelector({
            addr: address(handler),
            selectors: selectors
        }));


        targetContract(address(handler)); // includes the handler contract in target
    }


    function invariant_supply() external {
        assertEq(address(weth).balance, handler.weth().totalSupply());
    }

    function invariant_balance() external {
        assertEq(address(weth).balance, handler.ghost_depositSum() - handler.ghost_withdrawSum());
    }

    function invariant_actorBalances() external {
        address[] memory actors = handler.getActors();
        uint256 totalWethBalance;
        for(uint256 i = 0; i < actors.length; ++i){ 
             totalWethBalance += weth.balanceOf(actors[i]);   
        }
        assertEq(totalWethBalance, address(weth).balance);
    }

    function addBalance(address actor, uint256 acc) external returns(uint256){
        return acc + weth.balanceOf(actor);
    }    
    function invariant_actorBalancesNew() external{
        uint256 totalWethBalance = handler.reduceActors(0, this.addBalance); //this needs to be added because its a external contract
        assertEq(totalWethBalance, address(weth).balance);
    }


    function assertInvalidBalance(address actor) external{
        assertGe(weth.totalSupply(), weth.balanceOf(actor));
    }
    function invariant_individualActorWethBalance() external{
        handler.forEachActor(this.assertInvalidBalance);
    }

    function invariant_callsummary() external{
        handler.callLogSummary();
    }
}