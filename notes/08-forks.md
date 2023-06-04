# Forking

## Mainnet fork using CLI

- To run a test with mainnet fork on CLI, we use following

`forge test --match-contract <contract name> --match-test <test name> --fork-url <mainnet-fork-url>`

- Mainnet fork url is something you need to generate - you can use alchemy to generate this
- This function forks the mainnet at the latest block

- You can also go to a specific block number by doing following

`forge test --match-contract <contract name> --match-test <test name> --fork-url <mainnet-fork-url> --fork-block-number <block number>`

- Forking is useful when we have to interact with mainnet contracts to simulate a almost real
  world case (only difference is game theoretic aspect of MEV bots are missing in a mainnet fork)

### Caching while forking

- if a `--fork-url` and `fork-block-number` are specified -> foundry caches the specific data of this block for future runs

- data is cached in `~/.foundry/cache/rpc/<chain name>/<block number>`

- to remove cache, we can just run `forge clean` - clean removes all build related artifcats and cache directories

- We can ignore caching completely by `--no-storage-caching`

### Using Etherscan to improve traces in forking

- Foundry supports identifying contracts in forked environment using etherscan api
- To do this, we need to specify etherscan api in --etherscan-api-key

`forge test --fork-url <your_rpc_url> --etherscan-api-key <your_etherscan_api_key>`

---

## Mainnet fork inside foundry

- To create a fork, we use `createFork`

```
uint256 mainnetForkId = vm.createFork(MAINNET_RPC_URL)
```

`createFork` returns a mainnetForkId that will be used when selecting a specific fork (in the scenario where we are working with multiple forks)

If no block number is specified, fork would happen at the latest block number

- To fork at a specific block number, use send block number as input

```solidity
vm.createFork(MAINNET_RPC_URL, <block_number>)
```

- Creating a fork does not mean a particular fork is selected. To select a particular fork, we use `vm.selectFork(<forkid>)`. Fork id is the id that is returned when calling create fork

- `vm.activeFork()` returns the fork id of current active fork

- Just like rolling a local chain using `roll`, we can roll a fork by using `vm.rollFork(<block number>)` -> this allows us to do real testing of time based contracts

---

## Caching in forks

- Each fork is a standalone EVM - > all forks use completely different storage
- Only state of `msg.sender` and `test` contract that is defined inside the test are persistent
- Any other contract state will not be persistent if we move contract to a different fork
- to make any given contracts (apart from contracts defined in setup persistent), we need to use vm.makePersistent()
