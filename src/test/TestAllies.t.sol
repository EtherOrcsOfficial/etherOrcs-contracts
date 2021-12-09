// // SPDX-License-Identifier: Unlicense
// pragma solidity 0.8.7;

// import "ds-test/test.sol";

// import "../Proxy.sol";
// import "../testnet/MumbaiAllies.sol";
// import "../ERC20.sol";


// contract TestAllies is DSTest {

//     MumbaiAllies allies;
//     ERC20        zug;
//     ERC20        shr;
//     ERC20        potions;

//     function setUp() external {
//         Proxy p = new Proxy(address(new MumbaiAllies()));
//         allies = MumbaiAllies(address(p));

//         zug = new ERC20();
//         shr = new ERC20();
//         potions = new ERC20();

//         shr.setMinter(address(this), true);
//         shr.setMinter(address(allies), true);
//         shr.mint(address(this), 10000000 ether);

//         allies.initialize(address(zug), address(shr), address(potions));
//         allies.setAuth(address(this), true);
//     }

//     function test_mint() external {
//         uint256 balBefore = shr.balanceOf(address(this));

//         allies.mintShaman();

//         uint256 balAfter = shr.balanceOf(address(this));

//         (uint8 skillCredits, uint16 level, uint32 lvlProgress, uint8 body, uint8 featA, uint8 featB, uint8 helm, uint8 mainhand, uint8 offhand, uint16 herbalism) = allies.shamans(1);

//         assertEq(balBefore - balAfter, 60 ether);
//         assertEq(allies.ownerOf(1), address(this));
//         assertEq(skillCredits, 100);
//         assertEq(level, 25);
//         assertEq(lvlProgress, 25000);
//         assertEq(herbalism, 0);
//         assertTrue(body > 0 && body <= 7);
//         assertTrue(helm > 0 && helm <= 7);
//         assertTrue(mainhand > 0 && mainhand <= 7);
//         assertTrue(offhand > 0 && offhand <= 7);
//     }

//     function test_mint_probabilities() external {

//         uint256[7] memory bodies =    [uint256(0),0,0,0,0,0,0];
//         uint256[7] memory helms =     [uint256(0),0,0,0,0,0,0];
//         uint256[7] memory mainhands = [uint256(0),0,0,0,0,0,0];
//         uint256[7] memory offhands =  [uint256(0),0,0,0,0,0,0];

//         for (uint256 i = 0; i < 3001; i++) {
//             allies.mintShaman();

//             (, , , uint8 b, , , uint8 h, uint8 m, uint8 o,) = allies.shamans(i + 1);
//             bodies[b - 1]++;
//             helms[h - 1]++;
//             mainhands[m - 1]++;
//             offhands[o - 1]++;
//         }

//         // Not a precise a test, but close
//         for (uint256 i = 0; i < 7; i++) {
//             emit log_named_uint("index", i);
//             assertTrue(bodies[i] / 100 == 3 || bodies[i] / 100 == 4, "failed for bodies");
//             assertTrue(helms[i] / 100 == 3 || helms[i] / 100 == 4, "failed for helm");
//             assertTrue(mainhands[i] / 100 == 3 || mainhands[i] / 100 == 4, "failed for mainhand");
//             assertTrue(offhands[i] / 100 == 3 || offhands[i] / 100 == 4, "failed for offhand");
//         }   

//         try allies.mintShaman() { fail(); } catch { }
//     }

//     function testFail_mint_failWithoutBS() external {
//         shr.burn(address(this), shr.balanceOf(address(this)));

//         allies.mintShaman();
//     }

//     function test_journey() external {
//         allies.mintShaman();

//         (, , , , uint8 b_h,,, uint8 b_m, uint8 b_o,) = allies.shamans(1);

//         allies.journey(1, 0, 0);

//         (uint8 skillPoints, , , , uint8 h,,, uint8 m, uint8 o,) = allies.shamans(1);

//         assertEq(skillPoints, 95);
//         assertTrue(h > 7);
//         assertTrue(b_h != h);
//         assertEq(m, b_m);
//         assertEq(o, b_o);
//     }

//     function testFail_journey_invalidLevel() external {
//         allies.mintShaman();

//         allies.journey(1, 1, 1);
//     }

//     function testFail_journey_invalidEquipment() external {
//         allies.mintShaman();

//         allies.journey(1,0, 4);
//     }

//     function testFail_journey_notYourAlly() external {
//         allies.mintShaman();

//         allies.journey(2,0, 1);
//     }

// }
