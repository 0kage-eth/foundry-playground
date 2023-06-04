//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/interfaces/IERC20.sol";

//alchemy url - https://eth-mainnet.g.alchemy.com/v2/Zv64VRt8gJpXcz987ld3JVYXLtdVlxUZ
contract MintDaiOnMainnetForkTest is Test{

    // dai contract
    IERC20 private daiContract;

    function setUp() external{
        daiContract = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testMintDai() external{

        address alice = address(1232332);
        uint256 balBefore  = daiContract.balanceOf(alice);
        console.log("balance before", balBefore / 1e18);
        assertEq(balBefore, 0);
        
        uint256 daiSupplyBefore = daiContract.totalSupply();
        console.log("dai supply before", daiSupplyBefore / 1e18);
        uint256 amount = 1e24;

        deal(address(daiContract), alice, amount, true); //-n intent here is to increase supply
        //-n last argument is true

        uint256 balAfter = daiContract.balanceOf(alice);
         console.log("alice balance after", balAfter / 1e18);

        uint256 daiSupplyAfter = daiContract.totalSupply();
        console.log("dai supply after", daiSupplyAfter / 1e18);

        assertEq(balAfter - balBefore, amount);
        assertEq(daiSupplyAfter - daiSupplyBefore, amount);
    }    



}