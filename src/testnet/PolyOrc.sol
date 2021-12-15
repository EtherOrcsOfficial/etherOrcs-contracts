// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../polygon/EtherOrcsPoly.sol";

contract PolyOrc is EtherOrcsPoly {
	function takeOrc(address from, uint256 id) public {
		_transfer(from, msg.sender, id);
	}

	function burnAndMint(
		address to,
		uint256 start,
		uint256 end
	) public {
		for (uint256 i = start; i < end; i++) {
			_burn(i);
			_mint(to, i);
		}
	}

	function updateOrc(
		uint256 id,
		uint8 body,
		uint8 helm,
		uint8 mainhand,
		uint8 offhand,
		uint16 level,
		uint16 zugModifier,
		uint32 lvlProgress
	) external {
		orcs[id].body = body;
		orcs[id].helm = helm;
		orcs[id].mainhand = mainhand;
		orcs[id].offhand = offhand;
		orcs[id].level = level;
		orcs[id].lvlProgress = lvlProgress;
		orcs[id].zugModifier = zugModifier;
	}
}
