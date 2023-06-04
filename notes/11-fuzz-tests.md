# Fuzz Tests

## Intro

- Fuzzing works by randomizing inputs that can be passed to function
- unlike manual tests where user decides the inputs, a fuzz test allows for a random input as input -> useful to understand edge case sceanrios & working with extreme events

---

## Assume and Bound

- `vm.assume` skips execution if input value is not in the assumption list

for eg `vm.assume(x > 0);` assumes that x will be >0 and skips execution if x == 0

-
