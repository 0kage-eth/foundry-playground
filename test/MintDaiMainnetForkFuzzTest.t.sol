//SPDX-License-Identifier:MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "../src/interfaces/IERC20.sol";

contract MintDaiMainnetForkFuzzTest is Test {
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    IERC20 private daiContract;
    uint256 private mainnetForkId;
    string private MAINNET_FORK_URL = vm.envString("MAINNET_RPC_URL");    
    function setUp() external{
        daiContract = IERC20(DAI);
        mainnetForkId = vm.createFork(MAINNET_FORK_URL);
    }

    function testTotalSupply(uint256 amount) external {
        vm.selectFork(mainnetForkId);
        uint256 supplyBefore = daiContract.totalSupply();
        amount = bound(amount, 1, 1e24);
        deal(DAI, address(this), amount, true);
        assertEq(supplyBefore + amount, daiContract.totalSupply());
        assertEq(daiContract.balanceOf(address(this)), amount);
    }

    function testBurnNonZeroDai(uint256 mintAmount, uint256 transferAmount) external{
        address alice = address(1);
        vm.selectFork(mainnetForkId);       
        mintAmount = bound(mintAmount, 0, 1e24);
        deal(DAI, address(this), mintAmount, true); // mint to this address & increase supply
                
        vm.assume(transferAmount > 0);
        vm.assume(transferAmount <= mintAmount);

        assertGt(transferAmount, 0);
        assertLe(transferAmount, mintAmount);

        daiContract.transfer(alice, transferAmount);
        assertEq(daiContract.balanceOf(address(this)), mintAmount - transferAmount);
        assertEq(daiContract.balanceOf(alice), transferAmount);
    }
}