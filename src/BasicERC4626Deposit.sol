//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IERC20Like{

    function balanceOf(address owner_) external view returns(uint256 balance_);

    function transferFrom(address from_, address to_, uint256 amount_) external returns(bool success_);


}

contract BasicERC4626Deposit {

    address public immutable asset;
    uint8 public immutable decimals;
    string public name;
    string public symbol;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    constructor(address _asset, string memory _name, string memory _symbol, uint8 _decimals){
        asset = _asset;
        decimals = _decimals;
        name = _name;
        symbol = _symbol;
    }

    function deposit(uint256 assets_, address receiver_) public returns (uint256 shares_){
        shares_ = convertToShares(assets_);

        require(assets_ != 0, "0 assets");
        require(receiver_!= address(0), "receiver 0 address");
        require(shares_ != 0, "0 shares");

        totalSupply += shares_;

        unchecked{
            balanceOf[msg.sender] += shares_; // sender balance will always be less than or equal to total supply
        }

        require(IERC20Like(asset).transferFrom(msg.sender, address(this), assets_), "asset transfer failed");

    }

    function transfer(address to_, uint256 amount_) public returns(bool success_){
        balanceOf[msg.sender] -= amount_;

        unchecked{
            balanceOf[to_] += amount_; // note that total supply does not change-> this should always work
        }
        return true;
    }

    function convertToShares(uint256 assets_) public view returns(uint256 shares_){
        uint256 _supply = totalSupply;

        shares_ = _supply == 0 ? assets_ : _supply * assets_ / totalAssets();
    }

    function totalAssets() public view returns(uint256 assets_){
        assets_ = IERC20Like(asset).balanceOf(address(this));
    }

    function userBalance(address user) public view returns(uint256){
        return balanceOf[user];
    }

}

