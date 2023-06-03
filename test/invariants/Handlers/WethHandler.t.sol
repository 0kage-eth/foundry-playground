//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "src/WETH9.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import "forge-std/console.sol";

contract WethHandler is CommonBase, StdCheats, StdUtils{

    WETH9 public weth;
    uint256 public ghost_depositSum;
    uint256 public ghost_withdrawSum;

    constructor(WETH9 _weth){
         weth = _weth;
         deal(address(this), 100 ether);
    }

    function deposit(uint256 amount) external {
        amount = bound(amount, 0, address(this).balance);
        _pay(msg.sender, amount);
        vm.prank(msg.sender);        
        weth.deposit{value: amount}();
        ghost_depositSum += amount;
    }

    function withdraw(uint256 amount) external {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        vm.startPrank(msg.sender);
        weth.withdraw(amount);
        _pay(address(this), amount);
        vm.stopPrank();
        ghost_withdrawSum += amount;
    }

    function sendDirectEth(uint256 amount) external {
        amount = bound(amount, 0, address(this).balance);
        _pay(msg.sender, amount);

        vm.prank(msg.sender);
        (bool success, ) = address(weth).call{value: amount}("");
        require(success, "direct eth transfer failed");
        ghost_depositSum += amount;
    }

    function transferWeth(uint256 amount, address alice, address bob) external{
        amount = bound(amount, 0, 1000 ether);
        vm.deal(alice, amount);

        vm.startPrank(alice);
        weth.deposit{value: amount}();
        ghost_depositSum += amount;
        weth.transfer(bob, amount);
        vm.stopPrank();
    }

    function transferFromWeth(uint256 amount, address alice, address bob) external {
        amount = bound(amount, 0, 100 ether);
        vm.deal(alice, amount);

        vm.startPrank(alice);
        weth.deposit{value: amount}();
        ghost_depositSum += amount;
        weth.approve(address(this), amount);
        vm.stopPrank();

        bool success = weth.transferFrom(alice, bob, amount);
        require(success, "transfer from alice to bob failed");
    }

    receive() payable external {

    }

    function _pay(address receiver, uint256 amount) internal {
        if(amount > 0){
       (bool success, ) = receiver.call{value: amount}("");
        require(success, "payment from handler failed");
        }
     }

}