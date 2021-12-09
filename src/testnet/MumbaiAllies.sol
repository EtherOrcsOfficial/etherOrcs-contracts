// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../polygon/EtherOrcsAlliesPoly.sol";

contract MumbaiAllies is EtherOrcsAlliesPoly {

    uint256 constant startId = 5050;

    // function mintShaman(uint256 amount) external {
    //     for (uint256 i = 0; i < amount; i++) {
    //         mintShaman();
    //     }
    // }

    // function mintShaman() public noCheaters {
    //     boneShards.burn(msg.sender, 60 ether);

    //     _mintShaman(_rand());
    // } 

    function setZug(address z_) external {
        require(msg.sender == admin);
        zug = ERC20(z_);
    }

    function setCastle(address c_) external {
        require(msg.sender == admin);
        castle = c_;
    }

    function setRaids(address r_) external {
        require(msg.sender == admin);
        raids = r_;
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


    function setMetadataHandler(address add) external {
        require(msg.sender == admin);
        metadaHandler = MetadataHandlerLike(add);
    }

    function initMint(address to, uint256 start, uint256 end) external {
        require(msg.sender == admin);
        for (uint256 i = start; i < end; i++) {
            _mint( to, i);
        }
    }

    // function _mintShaman(uint256 rand) internal returns (uint16 id) {
    //     id = uint16(shSupply + 1 + startId); //check that supply is less than 3000
    //     require(shSupply++ <= 3000, "max supply reached");

    //     // Getting Random traits
    //     uint8 body = _getBody(_randomize(rand, "BODY", id));

    //     uint8 featB    = uint8(_randomize(rand, "featB",     id) % 22) + 1; 
    //     uint8 featA    = uint8(_randomize(rand, "featA",    id) % 20) + 1; 
    //     uint8 helm     = uint8(_randomize(rand, "HELM",     id) %  7) + 1;
    //     uint8 mainhand = uint8(_randomize(rand, "MAINHAND", id) %  7) + 1; 
    //     uint8 offhand  = uint8(_randomize(rand, "OFFHAND",  id) %  7) + 1;

    //     _mint(msg.sender, id);

    //     shamans[id] = Shaman({skillCredits:100, level: 25, lvlProgress: 25000, body: body, featA: featA, featB:featB, helm:helm, mainhand:mainhand, offhand:offhand, herbalism: 0});
    // }

    // function _getBody(uint256 rand) internal pure returns (uint8) {
    //     uint256 sixtyFivePct = type(uint16).max / 100 * 62;
    //     uint256 nineSevenPct = type(uint16).max / 100 * 97;
    //     uint256 nineNinePct  = type(uint16).max / 100 * 99;

    //     if (rand < sixtyFivePct) return uint8(rand % 5) + 1;
    //     if (rand < nineSevenPct) return uint8(rand % 4) + 6;
    //     if (rand < nineNinePct) return 10;
    //     return 11;
    // } 

}