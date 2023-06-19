# Fuzz Tests

## Intro

- Fuzzing works by randomizing inputs that can be passed to function
- unlike manual tests where user decides the inputs, a fuzz test allows for a random input as input -> useful to understand edge case sceanrios & working with extreme events

---

## Assume and Bound

- `vm.assume` skips execution if input value is not in the assumption list

for eg `vm.assume(x > 0);` assumes that x will be >0 and skips execution if x == 0

---

## Add specific contracts and selectors

By default, foundry tries to fuzz every single contract setup inside the setUp. This is often a wastage of resources because a lot of redundant tests are really not required at times. To avoid this, we can specific select contracts to fuzz using `TargetContract` and we can also spefify select function selectors by passing an array of selectors to `fuzzSelector` that takes the address and selectors array

For eg.

```
    function setUp() external{
        Weth9 _weth = new Weth9();
        Weth9Handler _handler = new Weth9Handler(_weth);

        bytes4[] memory selectors = new bytes4[](3);

        selectors.add(_handler.deposit.selector);
        selectors.add(_handler.withdraw.selector);
        selectors.add(_handler.sendfallbacl.selector);

        targetContract.add(address(handler));
        fuzzSelector(address(handler), selectors);
        targetSelector.add(fuzzSelector);
    }
```

Note in above example, we have added handler address to the targetContract. Fuzzing will only be done on this target Contract. In order to prevent wastage of resources within this contract, note that fuzzSelector is added to targetSelector - only the 3 selectors declared here will be used for fuzzing. This maximizes resoiurces
