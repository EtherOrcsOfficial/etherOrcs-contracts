// // SPDX-License-Identifier: Unlicense
// pragma solidity 0.8.7;

// import "ds-test/test.sol";

// import "./mocks/Mocks.sol";

// import "../Castle.sol";
// import "../Proxy.sol";
// import "../inventory/InventoryManagerAllies.sol";  

// import "../testnet/Rinkorc.sol";
// import "../testnet/PolyOrc.sol";
// import "../testnet/MumbaiAllies.sol";

// import "../mainnet/Zug.sol";
// import "../mainnet/Raids.sol";
// import "../mainnet/HallOfChampions.sol"; 
// import "../mainnet/EtherOrcsAllies.sol";

// import "../polygon/RaidsPoly.sol";
// import "../polygon/EtherOrcsItems.sol";
// import "../polygon/HallOfChampionsPoly.sol";
// import "../polygon/PotionVendorPoly.sol";  
// import "../polygon/InventoryManagerItems.sol";  

// import "../polygon/GamingOraclePoly.sol";


// abstract contract Hevm {
//     // sets the block timestamp to x
//     function warp(uint256 x) public virtual;

//     // sets the block number to x
//     function roll(uint256 x) public virtual;

//     // sets the slot loc of contract c to val
//     function store(
//         address c,
//         bytes32 loc,
//         bytes32 val
//     ) public virtual;

//     function ffi(string[] calldata) external virtual returns (bytes memory);
// }

// contract OrcsBaseTest is DSTest {

//     Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

//     Rinkorc orcsMain;
//     PolyOrc orcsPoly;

//     MumbaiAllies    alliesPoly;
//     EtherOrcsAllies alliesMain;

//     // Tokens need to be their own contract (Zug.sol, ZugPoly.sol, etc..)
//     MockERC20 zug;
//     MockERC20 pzug;
//     MockERC20 boneShards;
//     MockERC20 pBoneShards;

//     Castle castleMain;
//     Castle castlePoly;
    
//     Raids raidsMain;
//     RaidsPoly raidsPoly;

//     HallOfChampions hallMain;
//     HallOfChampionsPoly hallPoly;

//     EtherOrcsItems itemsPoly;

//     MockMainPortal portalMain;

//     MockGamingOracle gamingOracle;


//     function init() internal {

//         /*/////////////////////////////////////
//                    DEPLOYMENTS 
//        /////////////////////////////////////*/

//         // Mainnet - Proxy
//         orcsMain   = Rinkorc(address(new Proxy(address(new Rinkorc()))));
//         alliesMain = EtherOrcsAllies(address(new Proxy(address(new EtherOrcsAllies()))));
//         castleMain = Castle(address(new Proxy(address(new Castle()))));
//         raidsMain  = Raids(address(new Proxy(address(new Raids()))));
//         hallMain   = HallOfChampions(address(new Proxy(address(new HallOfChampions()))));

//         // Mainnet - Tokens
//         zug        = new MockERC20();
//         boneShards = new MockERC20();


//         portalMain = MockMainPortal(address(new Proxy(address(new MockMainPortal()))));

//         InventoryManagerAllies inv = new InventoryManagerAllies();


//         // Poly - Proxy
//         orcsPoly   = PolyOrc(address(new Proxy(address(new PolyOrc()))));
//         alliesPoly = MumbaiAllies(address(new Proxy(address(new MumbaiAllies()))));
//         castlePoly = Castle(address(new Proxy(address(new Castle()))));
//         raidsPoly  = RaidsPoly(address(new Proxy(address(new RaidsPoly()))));
//         itemsPoly  = EtherOrcsItems(address(new Proxy(address(new EtherOrcsItems()))));

//         pzug        = new MockERC20();
//         pBoneShards = new MockERC20();
//         hallPoly    = HallOfChampionsPoly(address(new Proxy(address(new HallOfChampionsPoly()))));
//         MockPolyPortal portalPoly = MockPolyPortal(address(new Proxy(address(new MockPolyPortal()))));
        
//         MockFxRoot fxRoot = new MockFxRoot();


//         PotionVendorPoly potionVendor = new PotionVendorPoly();
//         gamingOracle = MockGamingOracle(address(new Proxy(address(new MockGamingOracle()))));

//          // TODO Inventory contracts are missing on both chains

//         /*/////////////////////////////////////
//                    SETUP - MAIN
//        /////////////////////////////////////*/

//         //MAINNET / GOERLI
//         // Orcs - Already set on mainnet
//         orcsMain.setCastle(address(castleMain));
//         orcsMain.setRaids(address(raidsMain));
//         orcsMain.setZug(address(zug));
//         orcsMain.setAuth(address(castleMain), true);

//         alliesMain.initialize(address(castleMain), address(boneShards), address(inv));

//         // Zug
//         zug.setMinter(address(orcsMain), true);
//         zug.setMinter(address(alliesMain), true);
//         zug.setMinter(address(raidsMain), true);
//         zug.setMinter(address(hallMain), true);
//         zug.setMinter(address(castleMain), true);

//         // BoneSards
//         boneShards.setMinter(address(alliesMain), true);
//         boneShards.setMinter(address(raidsMain), true);
//         boneShards.setMinter(address(castleMain), true);

//         // Portal - Needs to use the networlks contracts, found in 
//         portalMain.initialize(address(fxRoot), address(1), address(portalPoly));
        
//         address[] memory adds = new address[](1);
//         adds[0] = address(castleMain);
//         portalMain.setAuth(adds, true);

//         // Castle
//         castleMain.initialize(address(portalMain), address(orcsMain), address(zug), address(boneShards));
//         castleMain.setAllies(address(alliesMain));

//         castleMain.setReflection(address(castleMain), address(castlePoly));
//         castleMain.setReflection(address(orcsMain), address(orcsPoly));
//         castleMain.setReflection(address(alliesMain), address(alliesPoly));
//         castleMain.setReflection(address(zug), address(pzug));
//         castleMain.setReflection(address(boneShards), address(pBoneShards));

//         //Raids
//         raidsMain.initialize(address(orcsMain), address(zug), address(boneShards), address(hallMain));
        
//         //Hall of Champions
//         hallMain.setAddresses(address(orcsMain), address(zug));
//         hallMain.setNamingCost(120);

//         /*/////////////////////////////////////
//                     SETUP - POLY
//         /////////////////////////////////////*/


//         orcsPoly.setCastle(address(castlePoly));
//         orcsPoly.setRaids(address(raidsPoly));
//         orcsPoly.setZug(address(pzug));
//         orcsPoly.setAuth(address(castlePoly), true);
//         orcsPoly.setAuth(address(raidsPoly), true); //need auth cause transfer is locked on poly
 
//         alliesPoly.initialize(address(pzug), address(pBoneShards), address(itemsPoly), address(raidsPoly), address(castlePoly), address(gamingOracle));
//         alliesPoly.setAuth(address(castlePoly), true);
//         alliesPoly.setAuth(address(raidsPoly), true);

//         pzug.setMinter(address(orcsPoly), true);
//         pzug.setMinter(address(alliesPoly), true);
//         pzug.setMinter(address(raidsPoly), true);
//         pzug.setMinter(address(hallPoly), true);
//         pzug.setMinter(address(castlePoly), true);
        

//         pBoneShards.setMinter(address(alliesPoly), true);
//         pBoneShards.setMinter(address(raidsPoly), true);
//         pBoneShards.setMinter(address(castlePoly), true);


//         itemsPoly.setMinter(address(alliesPoly), true);
//         itemsPoly.setMinter(address(raidsPoly), true);
//          itemsPoly.setMinter(address(potionVendor), true);

//         portalPoly.initialize(address(fxRoot), address(portalMain));


//         address[] memory addsPoly = new address[](1);
//         addsPoly[0] = address(castlePoly);
//         portalPoly.setAuth(addsPoly, true);

//         castlePoly.initialize(address(portalPoly), address(orcsPoly), address(pzug), address(pBoneShards));
//         castlePoly.setAllies(address(alliesPoly));

//         castlePoly.setReflection(address(castleMain), address(castlePoly));
//         castlePoly.setReflection(address(orcsMain), address(orcsPoly));
//         castlePoly.setReflection(address(alliesMain), address(alliesPoly));
//         castlePoly.setReflection(address(zug), address(pzug));
//         castlePoly.setReflection(address(boneShards), address(pBoneShards));

//         raidsPoly.initialize(address(orcsPoly), address(pzug), address(pBoneShards), address(hallPoly));
//         raidsPoly.init(address(alliesPoly), address(potionVendor), address(itemsPoly), address(gamingOracle));

//         gamingOracle.setAuth(address(raidsPoly), true);
//         gamingOracle.setAuth(address(alliesPoly), true);


//         //TODO need to initMint

//         // Used for testing only
//         hevm.roll(100000);
//         hevm.warp(1636580705);
//     } 

//     function test_sanity() external {
//         assertTrue(true);
//     }
// }

// contract TestPortal is OrcsBaseTest {

//     function setUp() external {
//         init();

//         orcsMain.initMint(address(orcsMain), 1, 50);
//         orcsPoly.initMint(address(castlePoly), 1, 50);

//         alliesPoly.initMint(address(castlePoly), 1, 50);

//         orcsMain.takeOrc(22);
//         orcsMain.updateOrc(22, 22, 22, 22, 22, 22, 22, 22000);

//         zug.setMinter(address(this), true);
//         zug.setMinter(address(portalMain), true);

//         orcsMain.setAuth(address(this), true);
//         alliesMain.setAuth(address(this), true);

//         orcsPoly.setAuth(address(this), true);
//         alliesPoly.setAuth(address(this), true);
    
//     }

//     function testTravel() external {
//         uint256[] memory ids = new uint256[](1);
//         ids[0] = 22;

//         zug.mint(address(this), 100);

//         castleMain.travel(ids, new uint256[](0), 100, 0);
//     }      

//     function testTravelAndBack() external {
//         uint256[] memory ids = new uint256[](1);
//         ids[0] = 22;

//         zug.mint(address(this), 100);

//         castleMain.travel(ids, new uint256[](0), 100, 0);

//         printOrc(orcsPoly, 22);
//         assertEq(pzug.balanceOf(address(this)), 100);

//         orcsPoly.updateOrc(22, 44, 44, 44, 44, 44, 20, 44000);

//         castlePoly.travel(ids, new uint256[](0), 100, 0);

//         printOrc(orcsPoly, 22);
//         assertEq(zug.balanceOf(address(this)), 100);

//     } 

//     function testTravelZugOnly() external {

//         zug.mint(address(this), 100);

//         castleMain.travel(new uint256[](0), new uint256[](0), 100, 0);

//     }

//     function testTravelFarmingOrc() external {
//         uint256[] memory ids = new uint256[](1);
//         ids[0] = 22;

//         orcsMain.doAction(22, EtherOrcs.Actions.FARMING);

//         castleMain.travel(ids, new uint256[](0), 0, 0);
        
//         printOrc(orcsPoly, 22);
//     }

//     function testFail_orcYouDontOwn() external {
//         uint256[] memory ids = new uint256[](2);
//         ids[0] = 23;
//         ids[1] = 22;

//         orcsMain.doAction(22, EtherOrcs.Actions.TRAINING);

//         castleMain.travel(ids, new uint256[](0), 0, 0);
//     }


//     function printOrc(PolyOrc orcs, uint256 id_) internal {
//         (uint8 body,uint8 helm,uint8 main,uint8 off,uint16 level,uint16 modf,uint32 lvlProgress) = orcs.orcs(id_);
    
//         emit log_named_uint("body", body);
//         emit log_named_uint("helm", helm);
//         emit log_named_uint("main", main);
//         emit log_named_uint("off", off);
//         emit log_named_uint("level", level);
//         emit log_named_uint("modf", modf);
//         emit log_named_uint("lpg", lvlProgress);
//     }
// }

// contract TestAlliesMain is OrcsBaseTest {

//     function setUp() external {
//         init();

//         alliesPoly.initMint(address(castlePoly), 1, 50);

//         zug.setMinter(address(this), true);
//         boneShards.setMinter(address(this), true);
//         alliesMain.setAuth(address(this), true);
//         alliesPoly.setAuth(address(this), true);

//         boneShards.mint(address(this), 10000000 ether);
//     }

//     function test_mint_shaman() external {
//         uint256 balBefore = boneShards.balanceOf(address(this));

//         alliesMain.mintShaman();

//         uint256 balAfter = boneShards.balanceOf(address(this));

//         (uint16 level, uint32 lvlProgress, uint16 herbalism, uint8 skillCredits, uint8 body, uint8 featA, uint8 featB, uint8 helm, uint8 mainhand, uint8 offhand) = alliesMain.shamans(5051);

//         assertEq(balBefore - balAfter, 60 ether);
//         assertEq(alliesMain.ownerOf(5051), address(this));
//         assertEq(skillCredits, 100);
//         assertEq(level, 25);
//         assertEq(lvlProgress, 25000);
//         assertEq(herbalism, 0);
//         assertTrue(body > 0 && body <= 7);
//         assertTrue(helm > 0 && helm <= 7);
//         assertTrue(mainhand > 0 && mainhand <= 7);
//         assertTrue(offhand > 0 && offhand <= 7);
//     }

//     function test_mint_ogre() external {
//         uint256 balBefore = boneShards.balanceOf(address(this));

//         alliesMain.mintOgre();

//         uint256 balAfter = boneShards.balanceOf(address(this));

//         (uint16 level, uint32 lvlProgress, uint16 modF, uint8 skillCredits, uint8 body, uint8 mouth, uint8 nose, uint8 eyes, uint8 armor, uint8 mainhand, uint8 offhand) = alliesMain.ogres(8051);

//         assertEq(balBefore - balAfter, 60 ether);
//         assertEq(alliesMain.ownerOf(8051), address(this));
//         assertEq(skillCredits, 100);
//         assertEq(level, 30);
//         assertEq(lvlProgress, 30000);
//         assertEq(modF, 0);
//         assertTrue(body > 0 && body <= 8);
//         assertTrue(armor > 0 && armor <= 6);
//         assertTrue(mainhand > 0 && mainhand <= 6);
//         assertTrue(offhand > 0 && offhand <= 6);
//     }

//     function testFail_mint_failWithoutBS() external {
//         boneShards.burn(address(this), boneShards.balanceOf(address(this)));

//         alliesMain.mintShaman();
//     }

// }

// contract TestAlliesPoly is OrcsBaseTest {

//     uint256 myId = 5051;

//     function setUp() external {
//         init();

//         alliesPoly.initMint(address(castlePoly), 5051, 5061);

//         zug.setMinter(address(this), true);
//         boneShards.setMinter(address(this), true);
//         alliesMain.setAuth(address(this), true);
//         alliesPoly.setAuth(address(this), true);

//         boneShards.mint(address(this), 10000 ether);

//         alliesMain.mintShaman();

//         uint256[] memory allies = new uint256[](1);
//         allies[0] = 5051;
//         castleMain.travel(new uint256[](0), allies, 0 , 0 );
//         gamingOracle.setAuth(address(this), true);
//     }

//     function test_journey() external {
//         (uint16 l, uint32 lvl, uint16 mF, , uint8 b_b, uint8 fA, uint8 fB, uint8 b_h, uint8 b_m, uint8 b_o) = alliesPoly.shamans(myId);

//         // allisPoly.updateShaman()
//         alliesPoly.doAction(myId, 1);

//         alliesPoly.startJourney(myId, 0, 0);

//         hevm.roll(block.number + 3);

//         alliesPoly.endJourney(myId);

//         (, , ,uint8 sc , uint8 b,,, uint8 h, uint8 m, uint8 o) = alliesPoly.shamans(myId);

//         assertEq(sc, 95);
//         assertTrue(h > 7);
//         assertTrue(b_h != h);
//         assertEq(m, b_m);
//         assertEq(o, b_o);

//         hevm.warp(block.timestamp + 14);
//         alliesPoly.startJourney(myId, 0, 0);

//     }

//     function testFail_journey_invalidLevel() external {
//         alliesPoly.startJourney(myId, 1, 1);
//     }

//     function testFail_journey_invalidEquipment() external {
//         alliesPoly.startJourney(myId,0, 4);
//     }

//     function testFail_journey_notYourAlly() external {
//         alliesPoly.startJourney(5052,0, 1);
//     }

//     function test_farming() external {

//         alliesPoly.doAction(5051, 1);

//         uint256 balBefore = itemsPoly.balanceOf(address(this),1);

//         hevm.warp(block.timestamp + 10 days);

//         alliesPoly.doAction(5051, 0);

//         uint256 balAfter = itemsPoly.balanceOf(address(this),1);

//         assertTrue(balAfter > balBefore);
//     }

//     function test_training() external {
//         alliesPoly.doAction(5051, 2);

//         (uint16 l1, , , , , , , , , ) = alliesPoly.shamans(myId);

//         hevm.warp(block.timestamp + 10 days);

//         alliesPoly.doAction(5051, 0);

//         (uint16 l2, , , , , , , , , ) = alliesPoly.shamans(myId);

//         assertTrue(l2 > l1);
//     }
// }


// contract TestRaids is OrcsBaseTest {

//     uint256[] myIds;
//     uint256[] myAllyIds;

//     function setUp() external {
//         init();

//         orcsPoly.initMint(address(castlePoly), 0, 50);
//         alliesPoly.initMint(address(castlePoly), 5051, 5061);

//         zug.setMinter(address(this), true);
//         boneShards.setMinter(address(this), true);
//         pzug.setMinter(address(this), true);
//         pBoneShards.setMinter(address(this), true);


//         alliesMain.setAuth(address(this), true);
//         alliesPoly.setAuth(address(this), true);
//         orcsMain.setAuth(address(this), true);
//         orcsPoly.setAuth(address(this), true);

//         boneShards.mint(address(this), 10000 ether);
//         pzug.mint(address(this), 1000000 ether);

//         alliesMain.mintShamans(3);

//         myAllyIds.push(5051);
//         myAllyIds.push(5052);
//         myAllyIds.push(5053);

//         gamingOracle.setAuth(address(this), true);

//         for (uint256 index = 1; index < 10; index++) {
//             orcsMain.initMint(address(this), index, index + 1 );
//             myIds.push(index);
//             orcsMain.updateOrc(index, 1, 1, 1, 1, 10, 1, 1000);
//         }
        
//         castleMain.travel(myIds, myAllyIds, 0 , 0);
//     }

//     function logCampaing(uint256 id) internal returns ( uint8 location, bool double, uint64 end, uint112 reward, uint64 blockSeed) {
//         (   location,  double,  end,  reward,  blockSeed) = raidsPoly.campaigns(id);

//         emit log_named_uint("loc", location);
//         emit log_named_uint("end", end);
//         emit log_named_uint("reward", reward);
//         emit log_named_uint("blockSeed", blockSeed);
//     }

//     function test_sendToRaid() public {
//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));

//         for (uint256 index = 0; index < myIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (,, uint256 end, ,) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }

//         alliesPoly.sendToRaid(myAllyIds, 0, true, new uint256[](myAllyIds.length));
//         for (uint256 index = 0; index < myAllyIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (,, uint256 end, ,) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }
//     }

//     function test_sendToRaidStaked() public {
//         orcsPoly.doActionWithManyOrcs(myIds, EtherOrcsPoly.Actions.FARMING);

//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));

//         for (uint256 index = 0; index < myIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (,, uint256 end,, ) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }

//         emit log_named_address("allies add", address(alliesPoly));
//         alliesPoly.doActionWithManyAllies(myAllyIds, 1);

//         alliesPoly.sendToRaid(myAllyIds, 0, true, new uint256[](myAllyIds.length));
//         for (uint256 index = 0; index < myAllyIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 5051), address(this));
//             (,, uint256 end, ,) = logCampaing(index + 5051);
//             assertEq(end, 1636580705 + 16 days);
//         }
//     }

//     function testFail_sendToRaidAndBackOrcs() public {
//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));

//         for (uint256 index = 0; index < myIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (, ,uint256 end,, ) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }

//         orcsPoly.returnFromRaid(myIds, EtherOrcsPoly.Actions.FARMING);
//     }

//     function testFail_sendToRaidAndBackAllies() public {
//         alliesPoly.sendToRaid(myAllyIds, 0, true, new uint256[](myAllyIds.length));
//         for (uint256 index = 0; index < myAllyIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (,, uint256 end, ,) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }

//         orcsPoly.returnFromRaid(myIds, EtherOrcsPoly.Actions.FARMING);
//     }

//     function test_sendToRaidAndBack() public {
//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));

//         uint256 endBlock;
//         for (uint256 index = 0; index < myIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             uint256 end;
//             (, , end,, endBlock ) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }

//         alliesPoly.sendToRaid(myAllyIds, 0, true, new uint256[](myAllyIds.length));
//         for (uint256 index = 0; index < myAllyIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (,, uint256 end, ,) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//         }

//         hevm.warp(block.timestamp + 16 days + 1);
//         hevm.roll(endBlock + 2);

//         alliesPoly.returnFromRaid(myAllyIds, 1);
//         orcsPoly.returnFromRaid(myIds, EtherOrcsPoly.Actions.FARMING);
//     }

//     function test_raidWithPotions() public {
//         itemsPoly.setMinter(address(this), true);

//         itemsPoly.mint(address(this), 1, 10 ether);

//         uint256[] memory pt = new uint256[](myIds.length);
//         pt[0] = 2;
//         orcsPoly.sendToRaid(myIds, 0, false, pt);
//     }

//     function testFail_sendToRaidAndBackDirectly() public {
//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));
//         uint256 endB;
//         for (uint256 index = 0; index < myIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//             (,, uint256 end,,uint256 endBlock ) = logCampaing(index + 1);
//             assertEq(end, 1636580705 + 16 days);
//             endB = endBlock;
//         }

//         hevm.warp(block.timestamp + 16 days + 1);
//         hevm.roll(endB + 2);

//         raidsPoly.unstake(2);
//     }

//     function testFail_stake() public {
//         raidsPoly.stakeManyAndStartCampaign(myIds, address(this), 0, false, new uint256[](myIds.length));
//     }

//     function test_multipleRaids() public {
//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));

//         for (uint256 index = 0; index < myIds.length; index++) {
//             assertEq(raidsPoly.commanders(index + 1), address(this));
//         }

//         (,, ,,uint256 endBlock ) = logCampaing(2);


//         hevm.warp(block.timestamp + 16 days + 1);
//         hevm.roll(endBlock + 1);

//         orcsPoly.startRaidCampaign(myIds, 0, true, new uint256[](myIds.length));

//         logCampaing(2);

//     }

//     function test_getClaim() public {
//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));

//         hevm.warp(block.timestamp + 16 days + 1);

//         raidsPoly.claim(myIds);
//     }

//     function testFail_noLevel() public {
//         orcsPoly.updateOrc(1, 1, 1, 1, 1, 1, 1, 1000);

//         orcsPoly.sendToRaid(myIds, 0, true, new uint256[](myIds.length));
//     }

//     function getArray(uint256 id) internal pure returns (uint256[] memory ids) {
//         ids = new uint256[](1);

//         ids[0] = id;
//     }

//     function test_allRaidPlaces() public {
//         uint256[] memory one = getArray(1);
//         orcsPoly.sendToRaid(one, 0, true, new uint256[](myIds.length));

//         orcsPoly.updateOrc(2, 2, 2, 2, 2, 20, 20, 20);
//         uint256[] memory two = getArray(2);
//         orcsPoly.sendToRaid(two, 1, true, new uint256[](myIds.length));

//         orcsPoly.updateOrc(3, 2, 2, 2, 2, 20, 20, 20);
//         uint256[] memory thr = getArray(3);
//         orcsPoly.sendToRaid(thr, 2, true, new uint256[](myIds.length));

//         orcsPoly.updateOrc(4, 2, 2, 2, 2, 35, 20, 20);
//         uint256[] memory frr = getArray(4);
//         orcsPoly.sendToRaid(frr, 3, true, new uint256[](myIds.length));

//         orcsPoly.updateOrc(5, 2, 2, 2, 2, 55, 20, 20);
//         uint256[] memory fv = getArray(5);
//         orcsPoly.sendToRaid(fv, 4, true, new uint256[](myIds.length));

//         hevm.warp(block.timestamp + 17 days);

//         raidsPoly.claim(myIds);
//     }

 

// }


// contract ItemsTest is OrcsBaseTest {

//     function setUp() external {
//         init();
//     }

//     function testMetadata() external {
//         InventoryManagerItems inv = new InventoryManagerItems();

//         itemsPoly.setInventoryManager(address(inv));

//         emit log_string(itemsPoly.uri(1));
//     }
// }