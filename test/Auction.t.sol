//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/Auction.sol";

contract TestAuction is Test{

    Auction public auction;
    uint256 public startDate;
    uint256 public endDate;    
    function setUp() external{
        startDate = block.timestamp + 1 days;
        endDate = block.timestamp + 7 days;

        auction = new Auction(startDate, endDate);
    }

    function testBidFail() external{
        vm.expectRevert("auction not active");
        auction.bid();
    }

    function testEndFail() external{
        vm.expectRevert("auction cannot be ended while active");
        auction.end();
    }

    // move ahead in time by 26 hours and then re-run test
    function testBidSuccess() external {
        vm.warp(block.timestamp + 26 hours);
        auction.bid();
    }

    function testFailBidAfterEndDate() external {
        vm.warp(endDate + 1 days);
        auction.bid();
    }

    function testSkipAndRewind() external {

        uint256 current = block.timestamp;

        //skipping by 100 seconds
        skip(100);
        assertEq(current + 100, block.timestamp);

        // rewind current time by 100 seconds
        rewind(100);
        assertEq(current, block.timestamp);
    }

    function testRoll() external {

        uint256 currentBlock = block.number;

        //roll ahead to a specific block number
        vm.roll(100);

        assertEq(block.number,  100);
    }

}