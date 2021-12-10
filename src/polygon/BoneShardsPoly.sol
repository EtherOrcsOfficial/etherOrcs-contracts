// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../ERC20.sol";

contract BoneShards is ERC20 {
    string public constant override name     = "pBoneShards";
    string public constant override symbol   = "pBONESHARDS";
    uint8  public constant override decimals = 18;
}