//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "../src/interfaces/IERC20Permit.sol";


// this contract is designed to transfer tokens from sender to receiver via a gaslessTokenTransfer
// name gaslessTokenTransfer is because, in practical scenario, the sender will transfer fees in advance to this contract
// when actual transfer happens, it happens without actual gas fee payment

contract GaslessTokenTransfer {
    function send(address token, address sender, 
                  address receiver, uint256 amount,
                  uint256 fee, uint256 deadline, uint8 v, bytes32 r, bytes32 s ) external {
        // in reality the fee can always be sent in advance
        // in this example, for clarity, we are sending fees along with amount to be transferred

        IERC20Permit tokenContract = IERC20Permit(token);

        tokenContract.permit(sender, address(this), amount + fee, deadline, v, r, s);

        // collect fees for enabling a transfer from sender to receiver
        tokenContract.transferFrom(sender, address(this), fee);

        // send amount from sender to receiver
        tokenContract.transferFrom(sender, receiver, amount);
    }
}