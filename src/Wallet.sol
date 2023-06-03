//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
contract Wallet {
    address payable public owner;

    event Deposit(address depositor, uint256 amount);
    event Withdraw(address withdraw, uint256 amount);
    constructor(){
        owner = payable(msg.sender);
    } 
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function setOwner(address newOwner) public{
        require(msg.sender == owner, "only owner can set new owner");
        owner = payable(newOwner);
    }

    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "only owner can withdraw");
        require(address(this).balance >= _amount, "not enough balance to withdraw");

        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount);    
    }

}