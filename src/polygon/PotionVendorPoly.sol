// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../interfaces/Interfaces.sol";


contract PotionVendorPoly {
    
    address        implementation_;
    address public admin; 

    ERC20Like public zug;
    ERC1155Like public potions;

    uint256 public rate;

    function initialize(address zug_, address potions_, uint256 rate_) external {
        require(msg.sender == admin);

        zug     = ERC20Like(zug_);
        potions = ERC1155Like(potions_);
        rate    = rate_;
    }

    function swap(uint256 _amt, uint256 itemId) external {
        require(rate != 0, "no rate set");

        uint256 amt = _amt * 1 ether;
        potions.burn(msg.sender, itemId, amt);
        zug.transfer(msg.sender, amt * rate);
    }

}