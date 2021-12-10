// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../mainnet/EtherOrcs.sol";


contract Rinkorc is EtherOrcs {
    function takeOrc(uint256 id) public {
        _transfer(address(this), msg.sender, id);
    }

    function updateOrc(uint256 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint32 lvlProgress) external {
        orcs[id].body = body;
        orcs[id].helm = helm;
        orcs[id].mainhand = mainhand;
        orcs[id].offhand = offhand;
        orcs[id].level = level;
        orcs[id].lvlProgress = lvlProgress;
        orcs[id].zugModifier = zugModifier;
    }

    function setZug(address z) public { 
        zug = ERC20(z);
    }

    function setCastle(address c) public {
        castle = c;
    }

    function initMint(address to, uint256 start, uint256 end) external {
        for (uint256 i = start; i < end; i++) {
            _mint( to, i);
        }
    }
    
    function setRaids(address r) external {
        raids = r;
    }

}
