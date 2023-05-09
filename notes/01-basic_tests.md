- To test all contracts, use

`forge test`

- To test all tests written in a singular contract, use

`forge test --match-contract <contract name>`

- To get a verbose representation of all test summary, we can use anywhere from `-v` to `-vvvv`

- To run all tests in a given file path

`forge test --match-path test/Counter2.t.sol`

- test looks for all files with a structure `*.t.sol` - it searches for tests written in these files

- `setUp()` is public or external function where we can setup the test. All variables can be initialized here, contracts can be deployed etc. Setup is run before each test is run

- all test functions should be preceeded with `test`

- `assertEq(a,b)` checks if two variables, a =b

- to check if the test should fail-> we write a test by `testFail`

- `expectRevert` allows us to specify the error that we expect when we run a function

- `--gas-report` allows us to generate gas calculations for each function in the Counter contract
