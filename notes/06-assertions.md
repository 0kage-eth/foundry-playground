# Assertions

## Equal To

`assertEq(uint256 a, uint256 b, string err)`

checks if `a==b` and throws error message `err` if not

Also exists for `bool`, `bytes`, `uint256[]`, `int256[]`

## Greater than & Greater Than or Equal to

`function assertGt(uint a, uint b) internal;`
`function assertGe(uint a, uint b) internal;`

functions above check greater than or greater than or equal to

- applicable for uint256 and int256

## Less than & Less Than or Equal to

`function assertLt(uint a, uint b) internal;`
`function assertLe(uint a, uint b) internal;`

function above check less than or less than or equal to
