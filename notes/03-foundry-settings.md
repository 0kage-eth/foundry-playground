- We can format code in foundry by

```
    $forge fmt
```

- We can get the .env file variables by using `vm.envString`. The variable is stored as a string

```
string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL")
```
