//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/MockERC20.sol";
import "src/BasicERC4626Deposit.sol";

contract HandlerERC7626Deposit {

    BasicERC4626Deposit private vault;
    MockERC20 private token;

    constructor() {
        token = new MockERC20("ZeroKage", "0Kage", 18);
        vault = new BasicERC4626Deposit(address(token), "zkVault", "zkV", 18);

    }
    function deposit(uint256 assets_) public returns(uint256 shares_) {

        token.mint(address(this), assets_);
        token.approve(address(vault), assets_);
        
        shares_ = vault.deposit(assets_, address(this));
    }

    function vaultTotalSupply() public view returns(uint256){
        return vault.totalSupply();
    }

    function vaultTotalAssets() public view returns(uint256){
        return vault.totalAssets();
    }

    function handlerBalance() public view returns(uint256){
        return vault.userBalance(address(this));
    }
    
    function handlerAssetBalance() public view returns(uint256){
        return token.balanceOf(address(this));
    }

}