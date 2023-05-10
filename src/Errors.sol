//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;

contract Errors {

    error NotAuthorized();
    error ErrorWithArgs(uint256 a, string b);
    function throwError() external{

        require(false, "Throw Error Always");
    }

    function revertError() external{
        revert NotAuthorized();
    }

    function revertErrorWithArguments(uint256 a, string memory b) external{
        revert ErrorWithArgs(a, b);
    }

}