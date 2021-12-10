// // SPDX-License-Identifier: Unlicense
// pragma solidity 0.8.7;

// import "ds-test/test.sol";

// import "./mocks/Mocks.sol";

// import "../Castle.sol";
// import "../Proxy.sol";

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
// import "../polygon/GamingOraclePoly.sol";

// contract OrcsBaseTest is DSTest {

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


//     function setUp() external {

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

//         MockMainPortal portalMain = MockMainPortal(address(new Proxy(address(new MockMainPortal()))));

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
//         GamingOraclePoly gamingOracle = new GamingOraclePoly();

//         // TODO Inventory contracts are missing on both chains

//         /*/////////////////////////////////////
//                    SETUP - MAIN
//        /////////////////////////////////////*/

//         //MAINNET / GOERLI
//         // Orcs - Already set on mainnet
//         orcsMain.setCastle(address(castleMain));
//         orcsMain.setRaids(address(raidsMain));
//         orcsMain.setZug(address(zug));
//         orcsMain.setAuth(address(castleMain), true);

//         alliesMain.initialize(address(castleMain), address(boneShards), address(1));

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
//         castleMain.initialize(address(portalMain), address(orcsMain), address(zug), address(zug));
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
//                    SETUP - POLY
//        /////////////////////////////////////*/

//         orcsPoly.setCastle(address(castlePoly));
//         orcsPoly.setRaids(address(raidsPoly));
//         orcsPoly.setZug(address(pzug));
//         orcsPoly.setAuth(address(castlePoly), true);

//         alliesPoly.initialize(address(pzug), address(pBoneShards), address(itemsPoly), address(raidsPoly), address(castlePoly), address(gamingOracle));
//         alliesPoly.setAuth(address(castlePoly), true);

//         pzug.setMinter(address(orcsPoly), true);
//         pzug.setMinter(address(alliesPoly), true);
//         pzug.setMinter(address(raidsPoly), true);
//         pzug.setMinter(address(hallPoly), true);
//         pzug.setMinter(address(castlePoly), true);

//         pBoneShards.setMinter(address(alliesPoly), true);
//         pBoneShards.setMinter(address(raidsPoly), true);
//         pBoneShards.setMinter(address(castlePoly), true);

//         itemsPoly.setMinter(address(alliesPoly), true);

//         portalPoly.initialize(address(fxRoot), address(portalMain));

//         castlePoly.initialize(address(portalPoly), address(orcsPoly), address(zug), address(zug));
//         castlePoly.setAllies(address(alliesPoly));

//         castleMain.setReflection(address(castleMain), address(castlePoly));
//         castleMain.setReflection(address(orcsMain), address(orcsPoly));
//         castleMain.setReflection(address(alliesMain), address(alliesPoly));
//         castleMain.setReflection(address(zug), address(pzug));
//         castleMain.setReflection(address(boneShards), address(pBoneShards));

//         raidsPoly.initialize(address(orcsPoly), address(pzug), address(pBoneShards), address(hallPoly));
//         raidsPoly.init(address(alliesPoly), address(potionVendor), address(itemsPoly));

//     } 


//     function test_sanity() external {
//         assertTrue(true);
//     }

// }
