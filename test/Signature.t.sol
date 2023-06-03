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

    function testIncorrectMessage() external {

        uint256 privateKey = 1243434;

        address pubKey = vm.addr(privateKey);
        bytes memory message = "this is correct msg";

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, keccak256(message));

        bytes memory incorrectMsg = "this is fake msg";

        address signer = ecrecover(keccak256(incorrectMsg), v, r, s);
        assertTrue(signer != pubKey, "Signer not equal to public Key");
    }

    function testIncorrectSender() external {
        uint256 privateKey  = 688666;
        uint256 fakeKey = 2393999;

        address pubKey = vm.addr(privateKey);
        bytes memory message = " I am 0Kage";

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, keccak256(message));

        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(fakeKey, keccak256(message));
        address signer = ecrecover(keccak256(message), v1, r1, s1);
        assertTrue(signer != pubKey, "Signer not public key");

    }

}