//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

contract Events {

    event Transfer(address indexed from, address indexed to, uint256 amount);
    error MismatchedArrays();
    function SingleTransfer(address from, address to, uint256 amount) external {
        emit Transfer(from, to, amount);
    }

    function MultiTransfer(address[] calldata from, address[] calldata to, uint256[] calldata amount) external {
        if(from.length != to.length || from.length != amount.length){
            revert MismatchedArrays();
        }
        
        for (uint256 i; i< from.length;){
            emit Transfer(from[i], to[i], amount[i]);
            unchecked{
                ++i;
            }
        }       
    }

}