//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;


contract Add3Numbers{

    uint256 public val1;
    uint256 public val2;
    uint256 public val3;

    function addToFirst(uint256 _val) public {
        val1 += _val;
        val3 += _val;
    }

    function addToSecond(uint256 _val) public {
        val2 += _val;
        val3 += _val;
    }

    //invariants here are : val3 = val1 + val2
    // second invariant here is that val3 >= val1 
    // I will define invariants in invariants file
}