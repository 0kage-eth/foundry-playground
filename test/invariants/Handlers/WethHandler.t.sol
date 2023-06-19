//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "src/WETH9.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import "forge-std/console.sol";
import {AddressSet, ManageAddressSets} from "../../../src/helpers/AddressSet.sol";
contract WethHandler is CommonBase, StdCheats, StdUtils{

    using ManageAddressSets for AddressSet;


    WETH9 public weth;
    uint256 public ghost_depositSum;
    uint256 public ghost_withdrawSum;
    uint256 public ghost_zeroWithdrawalCount;

    AddressSet private actors;
    address private currentActor;
    
    mapping(bytes32 => uint256) public calls;

    modifier countCall(bytes32 selector) {
        calls[selector] += 1;
        _;
    }
    constructor(WETH9 _weth){
         weth = _weth;
         deal(address(this), 100 ether);
    }

    function deposit(uint256 amount) createActor countCall("deposit") external  {
        amount = bound(amount, 0, address(this).balance);
        _pay(currentActor, amount);
        
        vm.prank(currentActor);        
        weth.deposit{value: amount}();
        ghost_depositSum += amount;

    }

    function withdraw(uint256 amount) createActor countCall("withdraw")  external {
        amount = bound(amount, 0, weth.balanceOf(currentActor));
        if(amount == 0) ghost_zeroWithdrawalCount++;
        vm.startPrank(currentActor);
        weth.withdraw(amount);        
        _pay(address(this), amount);
        vm.stopPrank();

        ghost_withdrawSum += amount;
    }

    function sendDirectEth(uint256 amount) createActor countCall("sendDirectEth")  external {
        amount = bound(amount, 0, address(this).balance);
        console.log("amount %i", amount);
        console.log("eth balance in weth contract %i", address(this).balance);

        _pay(currentActor, amount);

        vm.prank(currentActor);
        (bool success, ) = address(weth).call{value: amount}("");
        require(success, "direct eth transfer failed");
        ghost_depositSum += amount;
    }

    // function transferWeth(uint256 amount, address alice, address bob) createActor external{
    //     amount = bound(amount, 0, 1000 ether);
    //     vm.deal(alice, amount);

    //     vm.startPrank(alice);
    //     weth.deposit{value: amount}();
    //     weth.transfer(bob, amount);
    //     vm.stopPrank();
        
    //     ghost_depositSum += amount;
    // }

    // function transferFromWeth(uint256 amount, address alice, address bob) createActor external {
    //     amount = bound(amount, 0, 100 ether);
    //     vm.deal(alice, amount);

    //     vm.startPrank(alice);
    //     weth.deposit{value: amount}();
    //     weth.approve(address(this), amount);
    //     vm.stopPrank();

    //     ghost_depositSum += amount;
    //     bool success = weth.transferFrom(alice, bob, amount);
    //     require(success, "transfer from alice to bob failed");
    // }

    receive() payable external {

    }

    function _pay(address receiver, uint256 amount) internal {
        if(amount > 0){
          (bool success, ) = receiver.call{value: amount}("");
          require(success, "payment from handler failed");
        }
     }

    // gives count of each sleector call
    // note that this will be equal to depth of call
    function callLogSummary() external view {
        console.log("Call log summary");
        console.log("------------------");
        console.log("deposit calls", calls["deposit"]);
        console.log("withdrawal calls", calls["withdraw"]);
        console.log("send direct eth calls", calls["sendDirectEth"] );
        console.log("zero withdrawal count", ghost_zeroWithdrawalCount);
    }
     modifier createActor() {
        currentActor = msg.sender;
        actors.add(msg.sender);
        _;
     }

     function getActorCount() public view returns(uint256){
        return actors.count();
     }

     function getActors() public view returns(address[] memory){
        return actors.addrs;
     }

     function forEachActor(function(address) external func) external {
        actors.forEach(func);
     }

     function reduceActors(uint256 startValue, function(address, uint256) external returns(uint256) func) public returns(uint256){
        return actors.reduce(startValue, func);
     }

}