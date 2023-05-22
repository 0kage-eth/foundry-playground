//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "forge-std/Test.sol";
import "src/MockERC20.sol";
import "src/BasicERC4626Deposit.sol";

contract HandlerERC7626Deposit is Test{

    BasicERC4626Deposit private vault;
    MockERC20 private token;
    uint256 MIN_ACTORS = 1;
    uint256 MAX_ACTORS = 25;

    //GHOST VARIABLES
    address[] public actors;
    address internal currentActor;


    modifier useActor(uint96 actorIndexSeed){
        currentActor = actors[bound(actorIndexSeed, 0, actors.length -1)];
        vm.startPrank(currentActor);
        _;
        vm.stopPrank();
    }
    constructor() {
        token = new MockERC20("ZeroKage", "0Kage", 18);
        vault = new BasicERC4626Deposit(address(token), "zkVault", "zkV", 18);

    }

    function _initializeActors(uint256 numActors_) internal {
        for(uint i; i< numActors_;){
            actors.push(vm.addr(1));

            unchecked{
                ++i;
            }
        }        
    }

    function _initializeVault() internal {
         uint256 _numActors;
         _numActors = bound(_numActors, MIN_ACTORS, MAX_ACTORS);
        _initializeActors(_numActors); //initialize actors
        _initializeTokens(); // set all token balances to 0

        _burnBalance(address(vault)); // set vault balance to 0
        vault.resetTotalSupply(); // hold current vault supply to realistic levels

        for (uint i; i < actors.length;){
            vault.resetUserSupply(actors[i]);
            unchecked{
                ++i;
            }
        }
    }

    function _burnBalance(address actor_) internal {
        uint256 _actorBalance = token.balanceOf(actor_); 

        // force all actor balances to 0 -> any tokens in wallet are basically burnt
        if( _actorBalance > 0){
            token.burn(actor_, _actorBalance);
        }
    }


    // make sure we start with 0 tokens in all user accounts
    // make sure vault has no balance to begin with
    function _initializeTokens() internal {
        for(uint i; i<actors.length; i++){
            
            _burnBalance(actors[i]);
             unchecked{
                ++i;
            }
        }
    }

    // purpose of this function is to randomize vault with X number of depositor
    // give it a txn history of y txns before we are going to deposit into the vault

    function depositHandler(uint256 assets_, uint96 actorIndexSeed) public useActor(actorIndexSeed) returns(uint256 shares_) {
        assets_ = bound(assets_, 1, 1e30);
        uint256 _totalSupply = 100 ether;
        uint256 _userSupply;
        
        _userSupply = bound(_userSupply, 0, _totalSupply); // setting some initial shares that are less than total supply




        emit log_named_uint("assets in deposit handler", assets_);
        token.mint(address(this), assets_);
        token.approve(address(vault), assets_);
        
       shares_ = vault.deposit(assets_, address(this));
    }

    function withdrawHandler(uint256 shares_) public returns(uint256 assets_){
        shares_ = bound(shares_, 0, handlerBalance()); 
        emit log_named_uint("shares in withdraw handler", shares_);       
        assets_ = vault.withdraw(shares_, address(this));
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