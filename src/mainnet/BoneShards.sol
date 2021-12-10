// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../ERC20.sol";

contract BoneShards is ERC20 {
    string public constant override name     = "BoneShards";
    string public constant override symbol   = "BONESHARDS";
    uint8  public constant override decimals = 18;
}