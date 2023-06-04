//SPDX-License-Identifier:MIT

pragma solidity 0.8.17;
import "../src/interfaces/IERC20.sol";
import "forge-std/Test.sol";


contract SimpleStorageContract{

    uint256 storageValue;

    function set(uint256 _val) public {
        storageValue = _val;
    }

    function get() public returns(uint256){
        return storageValue;
    }
}
contract MintDaiOnMainnetFork2 is Test{

    IERC20 private daiContract;
    uint256 private mainnetFork;
    uint256 private optimismFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    string OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    function setUp() external {
        mainnetFork =  vm.createFork(MAINNET_RPC_URL);
        optimismFork = vm.createFork(OPTIMISM_RPC_URL);
    }

    function testRollFork() external {
        vm.selectFork(mainnetFork);
        console.log("original block number", block.number);

        vm.rollFork(17404201);
        console.log("block number after rolling", block.number);
        assertEq(block.number, 17404201 );
    }


    function testFlipFork() external {

        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);


        vm.selectFork(optimismFork);
        assertEq(vm.activeFork(), optimismFork);
    }

    function testFailPersistentContract() external {
        vm.selectFork(mainnetFork);
        SimpleStorageContract storageContract = new SimpleStorageContract();
        storageContract.set(2223);

        vm.selectFork(optimismFork);
        assertEq(storageContract.get(), 2223);
    }

    function testPersistentContract() external {
        vm.selectFork(mainnetFork);

        SimpleStorageContract storageContract = new SimpleStorageContract();
        
        storageContract.set(121222);

        vm.makePersistent(address(storageContract)); //-persist state of this contract

        vm.selectFork(optimismFork);
        assertEq(vm.activeFork(), optimismFork);
        assertEq(storageContract.get(), 121222);
    }



}