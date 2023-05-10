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

To add a new npm package, we can do the following

```
    $yarn add @openzeppelin/contracts
```

Now, to tell forge the location of the openzeppelin library, we create a file called `remappings.txt`

```
    $touch remappings.txt
```

Once done, we then create a remapping inside this

```
    @openzeppelin/ = node_modules/@openzeppelin
```

This tells foundry to look for files in specific location -> we can now go and call for a specific file,

```
    import "@openzeppelin/contracts/access/Ownabale.sol"
```
