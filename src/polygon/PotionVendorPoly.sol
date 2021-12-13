// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../interfaces/Interfaces.sol";


contract PotionVendorPoly {
    
    address        implementation_;
    address public admin; 

    ERC20Like zug;
    ERC1155Like potions;

    uint256 rate;

    uint256 public constant POTION_ID = 1; 

    function init(address zug_, address potions_, uint256 rate_) external {
        require(msg.sender == admin);

        zug     = ERC20Like(zug_);
        potions = ERC1155Like(potions_);
        rate    = rate_;
    }

    function swap(uint256 _amt) external {
        require(rate != 0, "no rate set");

        uint256 amt = _amt + 1 ether;
        potions.burn(msg.sender, POTION_ID, amt);
        zug.transfer(msg.sender, amt * rate);
    }

}