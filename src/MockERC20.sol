//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {

    constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_, decimals_){}

    function mint(address recipient, uint256 amount_) external {
        _mint(recipient, amount_);
    }

    function burn(address from_, uint256 amount_) external {
        _burn(from_, amount_);
    }
}
