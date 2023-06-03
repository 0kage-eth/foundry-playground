
//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "src/GaslessTokenTransfer.sol";
import "forge-std/Test.sol";
import "../src/utils/ERC20Permit.sol";

contract TestGaslessTokenTransfer is Test{

    ERC20Permit private token;
    GaslessTokenTransfer private gasless;
    uint256 PRIVATE_KEY = 56777;
    address private sender;
    address private receiver;
    uint256 private deadline;

    uint256 private constant AMOUNT = 5000;
    uint256 private constant FEE = 100;

    function setUp() external{

        token = new ERC20Permit("ZeroKage", "0Kage", 18);
        gasless = new GaslessTokenTransfer();
        sender = vm.addr(PRIVATE_KEY);
        receiver = address(888);

        //mint tokens to sender first
        token.mint(sender, AMOUNT + FEE);
        deadline = block.timestamp + 100;
    }

    function _generateMessageHash(address owner,
            address spender, uint256 value, uint256 deadline) 
            private view returns(bytes32) {
        return keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        token.DOMAIN_SEPARATOR(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                token.nonces(owner),
                                deadline
                            )
                        )
                    )
                );
    }

    function testTokenTransfer() external{
                // sender signs a message to permit 
        bytes32 messageHash = _generateMessageHash(sender, address(gasless), AMOUNT + FEE, deadline);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PRIVATE_KEY, messageHash);

        gasless.send(address(token), sender, receiver, AMOUNT, FEE, deadline, v, r, s);

        assertEq(token.balanceOf(receiver), AMOUNT);
        assertEq(token.balanceOf(address(gasless)), FEE);
        assertEq(token.balanceOf(sender), 0);
    }


}
