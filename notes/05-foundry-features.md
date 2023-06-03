## Foundry features

### Pranks

`vm.prank(alice)`
pranks as if the next statement is run by alice's wallet

```
vm.startPrank(alice)
... //@audit all lines in between are assumed to be txns initiated by alice
vm.stopPrank()

```

Set to a specific wallet and execute all txns as that wallet owner - all lines between `startPrank` and `stopPrank` assume this

---

### Errors

`vm.expectRevert(bytes())` or `vm.expectRevert(string)` expects revert with a specific bytes or string

`vm.expectRevert(Contract.CustomError.selector)` reverts with a custom error selector

If custom error also captures parameters,
`vm.expectRevert(abi.encodeWithSelector(CustomError.selector, 1, 2))`

We can label errors in `assertEq` as follows

`assertEq(a, b, "a != b")";`

In above example, when we run the test using `-vvv`, we see that error will be highlighted if there is an assertion failure. This way, we can easily pinpoint which particular assertion failed.

---

### Events

3 steps for capturing events

_Step 1_ - First setup structure of event that would be emitted
`vm.expectEmit(true, true, false, true)` expects that an event will be emitted. First 3 arguments refer to indexed parameters and last refers to data. If that argument is expected to be emitted, mark `true` or else mark false.

_Step 2_ - Setup expected event that is expected with arguments

`emit Transfer(address(this), address(124), 200)` setups the event that we are expecting to be emitted by a function call

_Step 3_ - Call the function that emits actual event

`Contract.transfer(address(this), address(124), 200)` -> here we call function that emits actual event

---

### Time

- To move ahead to a specific time, we use `vm.warp(<timestamp>)`
- To increase current time by `N` seconds, we use `vm.skip(N)`
- To decrease current time by `N` seconds, we use `vm.rewind(N)`
- To move to a specific block number `B`, we use `vm.roll(B)`

---

### Persistent

- To make contracts persistent across tests, we can use `vm.makePersistent(<contract address>)`

```
vm.makePersistent(address(WETH))
```
