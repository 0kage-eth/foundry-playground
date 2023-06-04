# Prank & Deal

## Deal

Foundry allows allocation of specific number of tokens to a given address, both in local testnet and mainnet forks.

The instruction here is `deal``

```
    deal(<token address>, <recipient address>, <amount>, <should increase supply>)
```

- You can deal any amount of tokens to specific recipient
- Note that, if the intention is to mint, supply needs to be increased. So last argument should be `true`

---
