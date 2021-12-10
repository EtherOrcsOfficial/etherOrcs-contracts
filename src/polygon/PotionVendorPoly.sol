// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../interfaces/Interfaces.sol";


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
        require(rate != 0, "no rate set");
        potions.burn(msg.sender, _amt);
        zug.transfer(msg.sender, _amt * rate);
    }

}