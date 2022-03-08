// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../mainnet/EtherOrcsAllies.sol";

contract TestAllies is EtherOrcsAllies {

    function mintFreeRogues(uint256 amount) external {
        for (uint256 i = 0; i < amount; i++) {
            _mintRogue(_rand());
        }
    }

}