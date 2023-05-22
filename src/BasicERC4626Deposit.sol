//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "forge-std/Test.sol";
interface IERC20Like{

    function balanceOf(address owner_) external view returns(uint256 balance_);

    function transferFrom(address from_, address to_, uint256 amount_) external returns(bool success_);

    function transfer(address to_, uint256 amount_) external returns(bool success_);
}

contract BasicERC4626Deposit is Test {

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
    
    function resetTotalSupply() external{
        totalSupply = 0;
    }

    function resetUserSupply(address user) external{
        delete balanceOf[user];
    }
    function deposit(uint256 assets_, address receiver_) public returns (uint256 shares_){
        emit log("**** inside vault deposit***");

        emit log_named_uint("vault asset balance before", totalAssets());
        emit log_named_uint("assets_", assets_);
        emit log_named_uint("total supply before _shares", totalSupply);
        emit log_named_uint("user supply before _shares", balanceOf[msg.sender]);

        shares_ = convertToShares(assets_);
        emit log_named_uint("calculated shares_", shares_);

        require(assets_ != 0, "0 assets");
        require(receiver_!= address(0), "receiver 0 address");
        require(shares_ != 0, "0 shares");

   

        totalSupply += shares_;
        emit log_named_uint("total supply after _shares", totalSupply);
        emit log_named_uint("msg.sender shares before", balanceOf[msg.sender]);

        unchecked{
            balanceOf[msg.sender] += shares_; // sender balance will always be less than or equal to total supply
        }
        emit log_named_uint("msg.sender shares after", balanceOf[msg.sender]);

        require(IERC20Like(asset).transferFrom(msg.sender, address(this), assets_), "asset transfer failed");
        emit log_named_uint("vault asset balance after", totalAssets());
    }

    function withdraw(uint256 shares_, address receiver_) public returns (uint256 assets_){
        require(receiver_ != address(0), "receiver is 0 address");
        require(shares_ <= balanceOf[msg.sender], "shares exceed balance");

        assets_ = convertToAssets(shares_);
        
        emit log("**** inside vault withdraw***");
        emit log_named_uint("input shares_", shares_);        
        emit log_named_uint("calculated assets_", assets_);
        emit log_named_uint("msg.sender shares before", balanceOf[msg.sender]);

        balanceOf[msg.sender] -= shares_; 
        emit log_named_uint("msg.sender shares after", balanceOf[msg.sender]);

        emit log_named_uint("msg.sender asset balance before", IERC20Like(asset).balanceOf(msg.sender));

        if(assets_ > 0){
            require(IERC20Like(asset).transfer(receiver_, assets_), "asset transfer failed");
        }

        emit log_named_uint("msg.sender asset balance after", IERC20Like(asset).balanceOf(msg.sender));        
    }

    function transfer(address to_, uint256 amount_) public returns(bool success_){
        balanceOf[msg.sender] -= amount_;

        unchecked{
            balanceOf[to_] += amount_; // note that total supply does not change-> this should always work
        }
        return true;
    }

    function convertToShares(uint256 assets_) public returns(uint256 shares_){
        uint256 _supply = totalSupply;
        emit log("inside convert to shares");
        emit log_named_uint("total supply", _supply);
        uint256 _totalAssets = totalAssets();
        emit log_named_uint("total assets", _totalAssets);
    
        shares_ = _supply == 0 || _totalAssets == 0 ? assets_ : _supply * assets_ / _totalAssets;
        emit log_named_uint("shares", shares_);
        emit log("exiting convert to shares");
    }

    function convertToAssets(uint256 shares_) public view returns(uint256 assets_){
        uint256 _supply = totalSupply;
        assets_ = _supply == 0 ? 0 : shares_* totalAssets() / _supply;
    }

    function totalAssets() public view returns(uint256 assets_){
        assets_ = IERC20Like(asset).balanceOf(address(this));
    }

    function userBalance(address user) public view returns(uint256){
        return balanceOf[user];
    }

}

