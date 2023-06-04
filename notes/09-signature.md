# Working with Signatures

- Foundry has a built in function to sign a message & check signature

- To sign a message, we need a private key and the hash of the messsage

- To get a public key from a private key, we can do

```solidity
address publicKey = vm.addr(privateKey)
```

- To sign a message, we use `vm.sign(privateKey, messageHash)`

- message hash is a bytes32 hash that is calculated by running `keccak256` on the message

- vm.sign returns 3 parameters related to signature - 1 byte v, 32 bytes r, 32 bytes s.

- Use `ecrecover` function to get back public key for a given combination of message hash, v.,r and s

- Check the signer emitted by ecrecover with the public key of signer

Normally, we woould have signed message offchain and then verified onchain. Foundry helps us to create a signature and also verify signer
