//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";



interface IWeth{
    function deposit() external payable;
    function withdraw(uint256 wad) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns(uint256);

    function approve(
        address guy, 
        uint256 wad
    ) external returns (bool);

    function transfer(
        address dst, 
        uint256 wad
    ) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) external returns (bool);
}


contract TestWethOnMainnet is Test{
    IWeth public weth;

    function setUp() external{
       weth = IWeth(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testTotalSupply() external{

        uint256 totalSupply = weth.totalSupply();
        console.log("weth total supply", totalSupply);
        uint256 totalEthInWethContract = address(weth).balance;
        assertEq(totalEthInWethContract, totalSupply);
    }

    //to run in mainnet, we use following command
    //forge test --match-contract TestWethOnMainnet --match-test testTotalSupply --fork-url https://eth-mainnet.g.alchemy.com/v2/Zv64VRt8gJpXcz987ld3JVYXLtdVlxUZ -vvv

    function testDepositWeth() external{

        address alice = address(88777);
        uint256 depositEth = 5 ether;
        deal(alice, depositEth);
        uint256 wethBalanceBefore = address(weth).balance;
        vm.prank(alice);
        weth.deposit{value: depositEth}();
        assertEq(address(weth).balance - wethBalanceBefore, depositEth);

    }
}

