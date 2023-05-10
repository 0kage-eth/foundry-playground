//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/Events.sol";

contract TestEvents is Test{

    Events public e;
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() external{
        e = new Events();
    }

    function testFullEvent() external {
        //1. expect the structure of the event
        vm.expectEmit(true, true, false, true);

        //2. emit the expected event
        emit Transfer(address(this), address(123), 100);

        //3. call the function that emits actual event
        e.SingleTransfer(address(this), address(123), 100);

    }

    // only test if to address and amount is corre3ct
    function testPartialEvent() external{
        //1. expect structure of event -> in this case, we only concern with to and amount
        vm.expectEmit(false, true, false, true);

        //2. emit the expected event
        emit Transfer(address(456), address(123), 200);

        //3. call function that emits the actual event
        e.SingleTransfer(address(this), address(123), 200);

        // note that this test passes even if from address is different
    }

    // tests an array of events emitted in a single function
    function testMultipleEvents() external {
        address[] memory froms = new address[](2);
        address[] memory tos = new address[](2);

        uint256[] memory amounts = new uint256[](2);

        // expect event emits
        for(uint256 i; i < froms.length;){
           vm.expectEmit(true, true, false, true);
           emit Transfer(froms[i], tos[i], amounts[i]);
            unchecked{
                ++i;
            }
        }
        e.MultiTransfer(froms, tos, amounts);
    }
}