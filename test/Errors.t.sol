//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/Errors.sol";

contract TestErrors is Test {

    Errors public errors;
    function setUp() external{
        errors = new Errors();
    }

    function testThrowError() external {
        vm.expectRevert("Throw Error Always");
        errors.throwError();
    }

    function testRevertError() external {
        vm.expectRevert(Errors.NotAuthorized.selector);
        errors.revertError();
    }

    function testRevertWithArguments() external{
        uint256 a = 32;
        string memory b = "super";

        vm.expectRevert(abi.encodeWithSelector(Errors.ErrorWithArgs.selector, a, b ));
        errors.revertErrorWithArguments(a,b);
    }
}