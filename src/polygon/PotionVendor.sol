// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

interface ERC20Like {
    function burn(address from, uint256 amount) external;
    function transfer(address to, uint256 amount) external;
}

contract PotionVendorPoly {
    
    address        implementation_;
    address public admin; 

    ERC20Like zug;
    ERC20Like potions;

    uint256 rate;

    function init(address zug_, address potions_, uint256 rate_) external {
        require(msg.sender == admin);

        zug     = ERC20Like(zug_);
        potions = ERC20Like(potions_);
        rate    = rate_;
    }

    function swap(uint256 _amt) external {
        potions.burn(msg.sender, _amt);
        zug.transfer(msg.sender, _amt * rate);
    }

}