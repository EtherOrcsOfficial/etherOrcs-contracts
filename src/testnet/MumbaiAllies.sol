// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../polygon/EtherOrcsAlliesPoly.sol";

contract MumbaiAllies is EtherOrcsAlliesPoly {

    uint256 constant startId = 5050;

    function getItem(uint8 location, uint256 rand) external  view returns(uint8 item){
        item = _getItemSh(locations[location], rand);
    }

    function setZug(address z_) external {
        require(msg.sender == admin);
        zug = ERC20Like(z_);
    }

    function setCastle(address c_) external {
        require(msg.sender == admin);
        castle = c_;
    }

    function setRaids(address r_) external {
        require(msg.sender == admin);
        raids = r_;
    }

    function forceTransfer(address owner_, address to_, uint256 start, uint256 end) external {
        require (auth[msg.sender], "not authed");
        for (uint256 i = start; i < end; i++) {
            _transfer(owner_,to_, i);
        }
    }

    function updateShaman(
        uint256 id,
        uint8 skillCredits_, 
        uint16 level_, 
        uint32 lvlProgress_, 
        uint8 body_, 
        uint8 featA_, 
        uint8 featB_, 
        uint8 helm_, 
        uint8 mainhand_, 
        uint8 offhand_, 
        uint16 herbalism_) external 
    {
        allies[id] = Ally({
            class: 1, 
            level: level_, 
            lvlProgress: lvlProgress_, 
            modF: herbalism_, 
            skillCredits: skillCredits_, 
            details: bytes22(abi.encodePacked(body_, featA_, featB_, helm_, mainhand_, offhand_))
        });
    }

}