// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../interfaces/Interfaces.sol";

contract HoardeUtilities {

    address orcs;
    address allies;
    address items;

    function claimForTheHoarde(uint256[] calldata ids) external {
        OrcishLike(orcs).claim(ids);
        OrcishLike(allies).claim(ids);
    }

    function useDummyMany(uint256[] calldata ids, uint256[] calldata amounts) external {
        require(ids.length == amounts.length, "invalid inputs");
        for (uint256 index = 0; index < ids.length; index++) {
            useDummy(ids[index], amounts[index]);
        }
    }

    function useDummy(uint256 id, uint256 amount) public {
        ERC1155Like(items).burn(msg.sender, 2, amount);
        if (id <= 5050) {
            (uint8 b, uint8 h, uint8 m, uint8 o, uint16 l, uint16 zM, uint32 lP) = _getnewOrcProp(id, amount);
            require(l != 0, "not valid Orc");

            OrcishLike(orcs).manuallyAdjustOrc(id,b,h,m,o,l, zM,lP);
        } else {
            (uint8 cl, uint16 l, uint32 lP, uint16 modF, uint8 sc, bytes22 d) = OrcishLike(allies).allies(id);
            require(l != 0, "not valid Ally");

            OrcishLike(allies).adjustAlly(id, cl, l + (4 * uint16(amount)), lP + (uint32(amount) * 4000), modF, sc, d);
        }
    }

    function _getnewOrcProp(uint256 id, uint256 amt) internal view returns(uint8 b, uint8 h, uint8 m, uint8 o, uint16 l, uint16 zM, uint32 lP) {
        ( b,  h,  m,  o,  l,  zM, lP) = OrcishLike(orcs).orcs(id);
        l = uint16(l + (4 * amt));
        lP = uint16(lP + (4000 * amt));
    } 


}