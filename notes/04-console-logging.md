- Foundry offers a method to console log values while debugging

first import `console.sol`

```
    import forge-std/console.sol
```

inside code, we can console log in opur tests. Make sure we don't have console log inside actual contracts (consume gas)

```
contract TestConsole{
    uint256 testCounter;

    function setCounter(uint256 newCtr){
        testCounter = newCtr;
        console.log("test counter %i", testCounter);
    }
}
```
