- To change the solidity version for compiling contracts, we can change settings in `foundry.toml`

Inside foundry.toml,

```
    solc_version = "0.8.17"
```

- For a complete list of options, go to [git repo of foundry](https://github.com/foundry-rs/foundry/tree/master/config)

- importing libraries in foundry (eg. openzeppelin, solmate etc)

```
    $forge install rari-capital/solmate
```

and then import a library contract, say ERC

```
    import "solmate/token/ERC20.sol"

    contract MockERC20 is ERC20 ("mock", "mc", 18){}
```

To update package, we can type following command

```
    $forge update lib/solmate
```

To remove package, we can type following command

```
    $forge remove solmate
```
