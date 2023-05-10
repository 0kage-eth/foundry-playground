//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;

import "../src/Counter.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract Counter2Test is Test {
    Counter private counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testIncrement() public {
        uint256 _num = counter.number();
        counter.increment();
        console.log("counter after increment %i" , counter.number());
        assertEq(counter.number(), _num + 1);
    }

    function testNumber() public {
        uint256 _num = 10;
        counter.setNumber(_num);
        console.log("counter after setting %i", counter.number());
        assertEq(counter.number(), _num);
    }

    function testFailIncrement() public {
        counter.setNumber(20);
        counter.increment();

        assertEq(counter.number(), 32);
    }

    function testUnderflow() public {
        vm.expectRevert(stdError.arithmeticError); //-n explore stdErrorr
        counter.decrement();
    }
}