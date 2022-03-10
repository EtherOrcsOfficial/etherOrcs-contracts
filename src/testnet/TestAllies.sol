// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../mainnet/EtherOrcsAllies.sol";

contract TestAllies is EtherOrcsAllies {

    function mintFreeRogues(uint256 amount) external {
        for (uint256 i = 0; i < amount; i++) {
            uint256 rand = _rand();

            uint256 id = _mintRogue(rand);

            Rogue memory rg = _rogue(allies[id].details);

            rg.armor    = uint8(_randomize(rand, "ARMIR", id) % 35) + 1;
            rg.mainhand = uint8(_randomize(rand, "MAINHAND", id) % 35) + 1;
            rg.offhand  = uint8(_randomize(rand, "OFFHAND", id) % 35) + 1;

            allies[id].details = bytes22(abi.encodePacked(rg.body, rg.face, rg.boots, rg.pants, rg.shirt, rg.hair, rg.armor, rg.mainhand, rg.offhand));
        }
    }

    function _rogue(bytes22 details) internal pure returns(Rogue memory rg) {
        uint8 body     = uint8(bytes1(details));
        uint8 face     = uint8(bytes1(details << 8));
        uint8 boots    = uint8(bytes1(details << 16));
        uint8 pants    = uint8(bytes1(details << 24));
        uint8 shirt    = uint8(bytes1(details << 32));
        uint8 hair     = uint8(bytes1(details << 40));
        uint8 armor    = uint8(bytes1(details << 48));
        uint8 mainhand = uint8(bytes1(details << 56));
        uint8 offhand  = uint8(bytes1(details << 64));

        rg.body     = body;
        rg.face     = face;
        rg.armor    = armor;
        rg.mainhand = mainhand;
        rg.offhand  = offhand;
        rg.boots    = boots;
        rg.pants    = pants;
        rg.shirt    = shirt;
        rg.hair     = hair;
    }

}