// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../ERC20.sol";

contract Zug is ERC20 {
    string public constant override name     = "ZUG";
    string public constant override symbol   = "ZUG";
    uint8  public constant override decimals = 18;
}