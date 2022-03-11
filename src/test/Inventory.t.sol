// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../../lib/ds-test/src/test.sol";

import "../Proxy.sol";
import "../inventory/InventoryManagerRogues.sol";
import "../inventory/InventoryManagerAllies.sol";
import "../inventory/InventoryRogues.sol";


contract InventoryTest is DSTest {


    InventoryManagerRogues invMan;
    InventoryManagerAllies alliesMan;
    

    function _getArray(uint256 id) internal pure returns (uint8[] memory ids) {
        ids = new uint8[](1);

        ids[0] = uint8(id);
    }

    function setUp() external {

        InventoryManagerAllies man2 = new InventoryManagerAllies();
        alliesMan = InventoryManagerAllies(address(new Proxy(address(man2))));

        InventoryManagerRogues man = new InventoryManagerRogues();
        invMan = InventoryManagerRogues(address(new Proxy(address(man))));

        alliesMan.setAddresses(address(0), address(0), address(0), address(invMan));

        invMan.setBodies(_getArray(1), address(new Bodies1()));
        invMan.setFaces(_getArray(2), address(new Faces1()));
        invMan.setBoots(_getArray(3), address(new Boots2()));
        invMan.setPants(_getArray(4), address(new Pants2()));
        invMan.setShirts(_getArray(5), address(new Shirts2()));
        invMan.setHairs(_getArray(6), address(new Hairs2()));
        invMan.setArmors(_getArray(7), address(new Armors3()));
        invMan.setMainhands(_getArray(8), address(new Mainhands3()));
        invMan.setOffhands(_getArray(9), address(new Offhands3()));
    }

    function test_getInventory() external {

        bytes22 details = bytes22(abi.encodePacked(uint8(1),uint8(2),uint8(3),uint8(4),uint8(5),uint8(6),uint8(7),uint8(8),uint8(9)));

        // (bool succ, bytes memory ret) = address(alliesMan).staticcall(abi.encodeWithSelector(InventoryManagerAllies.getTokenURI.selector, 1,3,1,1,1,details));

        invMan._rogueUpper(details);

        emit log(invMan.getArmorName(uint8(7)));

        // emit log(alliesMan.getTokenURI(1, 3, 1, 1, 1, details));
        fail();
    }

}