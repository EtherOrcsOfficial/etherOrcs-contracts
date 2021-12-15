// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../ERC20.sol";

contract ZugPoly is ERC20 {
	string public constant override name = "pZUG";
	string public constant override symbol = "pZUG";
	uint8 public constant override decimals = 18;
}
