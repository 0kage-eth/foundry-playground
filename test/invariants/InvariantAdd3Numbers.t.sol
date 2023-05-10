//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/Add3Numbers.sol";

contract InvariantAdd3Numbers is Test{
    
    Add3Numbers public addNumbers;

    function setUp() external {
        addNumbers = new Add3Numbers();
    }

    function invariant_sum() external{
        assertEq(addNumbers.val3(), addNumbers.val1() + addNumbers.val2());
    }

    function invariant_greaterThanOrEqual() external{
        assertGe(addNumbers.val3(), addNumbers.val1());
    }

}