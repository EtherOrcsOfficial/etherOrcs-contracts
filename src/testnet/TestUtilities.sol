// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../polygon/HordeUtilities.sol";

contract TestUtilities is HordeUtilities {

    function getRocks() external {
        ERC1155Like(items).burn(msg.sender, 2, 3 * 1 ether);
    }
}