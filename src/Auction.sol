//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

contract Auction{

    address public owner;
    uint256 public startDate;
    uint256 public endDate;

    constructor(uint256 _startDate, uint256 _endDate) {
        startDate = _startDate; 
        endDate = _endDate; 
        owner = msg.sender;
    }

    modifier  onlyOwner {
        require(msg.sender == owner, "not owner");
        _;
    }

    function setStartDate(uint256 newStartDate) onlyOwner external{
        require(newStartDate < endDate, "new start date after end date");
        startDate = newStartDate;
    }

    function setEndDate(uint256 newEndDate) onlyOwner external {
        require(newEndDate > startDate, "new end date before start date");
        endDate = newEndDate;
    }

    function bid() external{
        require(block.timestamp >= startDate && block.timestamp < endDate, "auction not active");
    }

    function end() external{
        require(block.timestamp >= endDate, "auction cannot be ended while active");
    }
}