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
        invMan.setFaces(_getArray(1), address(new Faces1()));
        invMan.setBoots(_getArray(1), address(new Boots1()));
        invMan.setPants(_getArray(1), address(new Pants1()));
        invMan.setShirts(_getArray(1), address(new Shirts1()));
        invMan.setHairs(_getArray(1), address(new Hairs1()));
        invMan.setArmors(_getArray(1), address(new Armors1()));
        invMan.setMainhands(_getArray(1), address(new Mainhands1()));
        invMan.setOffhands(_getArray(1), address(new Offhands1()));
    }

    function test_getInventory() external {

        bytes22 details = bytes22(abi.encodePacked(uint8(1),uint8(1),uint8(1),uint8(1),uint8(1),uint8(1),uint8(1),uint8(1),uint8(1)));

        (bool succ, bytes memory ret) = address(alliesMan).staticcall(abi.encodeWithSelector(InventoryManagerAllies.getTokenURI.selector, 1,3,1,1,1,0x02141910111200000000000000000000000000000000));

        emit log_bytes(ret);
        
    }

}