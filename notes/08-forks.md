## Mainnet fork using CLI

- To run a test with mainnet fork on CLI, we use following

`forge test --match-contract <contract name> --match-test <test name> --fork-url <mainnet-fork-url>`

- Mainnet fork url is something you need to generate - you can use alchemy to generate this
- This function forks the mainnet at the latest block

- You can also go to a specific block number by doing following

`forge test --match-contract <contract name> --match-test <test name> --fork-url <mainnet-fork-url> --fork-block-number <block number>`

---

## Mainnet fork inside foundry

- To create a fork, we use `createFork`

```
vm.createFork(MAINNET_RPC_URL)
```

If no block number is specified, fork would happen at the latest block number

- To fork at a specific block number, use send block number as input

```solidity
vm.createFork(MAINNET_RPC_URL, <block_number>)
```
