- To create a fork, we use `createFork`

```
vm.createFork(MAINNET_RPC_URL)
```

If no block number is specified, fork would happen at the latest block number

- To fork at a specific block number, use send block number as input

```
vm.createFork(MAINNET_RPC_URL, <block_number>)
```
