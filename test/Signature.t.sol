//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";

contract TestSignature is Test {


    function testSignature() external {

        uint256 privateKey = 12323233;

        address publicKey = vm.addr(privateKey);
        bytes memory message = "Hey you! How are you";
        bytes32 messageHash = keccak256(message);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        address signer = ecrecover(messageHash, v, r, s);
        assertEq(signer, publicKey);
    }

}