// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../interfaces/Interfaces.sol";

contract HordeUtilities {

    address        implementation_;
    address public admin; 

    address orcs;
    address allies;
    address items;

    function setAddresses(address orcs_, address allies_, address items_) external {
        require(msg.sender == admin);
        orcs = orcs_;
        allies = allies_;
        items = items_;
    }

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
        ERC1155Like(items).burn(msg.sender, 2, amount * 1 ether);
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
        lP = uint32(lP + (4000 * amt));
    } 


    function userRock(uint256 id_) external {
        (uint8 class, , , , , ) = OrcishLike(allies).allies(id_);
        require(class == 2, "not an ogre");

        ERC1155Like(items).burn(msg.sender, 99,  3 ether);

        (uint16 level, uint32 lvlProgress, uint16 modF, uint8 skillCredits, uint8 body, uint8 mouth, uint8 nose, uint8 eyes, uint8 armor, uint8 mainhand, uint8 offhand) = OrcishLike(allies).ogres(id_);

        mouth = (9 - body) * 3 + mouth;
        nose  = (9 - body) * 3 + nose;
        eyes  = (9 - body) * 3 + eyes;
        body  = 9;

        OrcishLike(allies).adjustAlly(id_, 2, level, lvlProgress, modF, skillCredits, bytes22(abi.encodePacked(body,mouth,nose,eyes,armor,mainhand,offhand)));
    }

}