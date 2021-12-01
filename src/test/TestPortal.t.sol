// // SPDX-License-Identifier: Unlicense
// pragma solidity 0.8.7;

// import "ds-test/test.sol";

// import "../testnet/Rinkorc.sol";

// import "../Castle.sol";
// import "../ERC20.sol";
// import "../Proxy.sol";

// import "../BoneShards.sol";

// import "./mocks/Mocks.sol";

// contract TestPortal is DSTest {

//     Rinkorc orcsMain;
//     Rinkorc orcsPoly;

//     Castle  castleMain;
//     Castle  castlePoly;
    
//     ERC20   zug;
//     ERC20   pzug;
    
//     BoneShards shr;
//     BoneShards pShr;

//     MockMainPortal portalMain;
//     MockPolyPortal portalPoly;

//     MockFxRoot fxRoot;

//     function setUp() external {
//         address orcsMainProxy = address(new Proxy(address(new Rinkorc())));
//         orcsMain = Rinkorc(orcsMainProxy);

//         address orcsPolygonProxy = address(new Proxy(address(new Rinkorc())));
//         orcsPoly  = Rinkorc(orcsPolygonProxy);    

//         zug  = new ERC20();
//         pzug = new ERC20();

//         shr = new BoneShards();
//         pShr = new BoneShards();

//         address castleMainProxy = address(new Proxy(address(new Castle())));
//         castleMain = Castle(castleMainProxy);

//         address castlePolyProxy = address(new Proxy(address(new Castle())));
//         castlePoly = Castle(castlePolyProxy);

//         address portalMainProxy = address(new Proxy(address(new MockMainPortal())));
//         portalMain = MockMainPortal(portalMainProxy);

//         address portalPolyProxy = address(new Proxy(address(new MockPolyPortal())));
//         portalPoly = MockPolyPortal(portalPolyProxy);

//         fxRoot = new MockFxRoot();

//         // Init Portals
//         portalMain.initialize(address(fxRoot), address(1), address(portalPoly));
//         portalPoly.initialize(address(fxRoot), address(portalMain));

//         address[] memory adds = new address[](1);
//         adds[0] = address(castleMain);
//         portalMain.setAuth(adds, true);

//         adds[0] = address(castlePoly);
//         portalPoly.setAuth(adds, true);

//         // Init Castles
//         castleMain.initialize(address(portalMain), address(orcsMain), address(zug), address(zug));
//         castlePoly.initialize(address(portalPoly), address(orcsPoly), address(pzug), address(pzug));

//         // Set reflectons
//         castleMain.setReflection(address(castleMain), address(castlePoly));
//         castleMain.setReflection(address(orcsMain), address(orcsPoly));
//         castleMain.setReflection(address(zug), address(pzug));

//         castlePoly.setReflection(address(castlePoly), address(castleMain));
//         castlePoly.setReflection(address(orcsPoly), address(orcsMain));
//         castlePoly.setReflection(address(pzug), address(zug));

//         // Set zug
//         orcsMain.setZug(address(zug));
//         zug.setMinter(address(orcsMain), true);
//         zug.setMinter(address(castleMain), true);

//         orcsMain.setCastle(address(castleMain));
//         orcsMain.setAuth(address(castleMain), true);
//         orcsMain.setAuth(address(this), true);

//         // Set zug
//         orcsPoly.setZug(address(pzug));
//         pzug.setMinter(address(orcsPoly), true);
//         pzug.setMinter(address(castlePoly), true);

//         orcsPoly.setCastle(address(castlePoly));
//         orcsPoly.setAuth(address(castlePoly), true);

//         zug.setMinter(address(this), true);
//         pzug.setMinter(address(this), true);

//         orcsMain.initMint(address(orcsMain), 1, 5051);
//         orcsPoly.initMint(address(castlePoly), 1, 5051);

//         orcsMain.takeOrc(22);
//         orcsMain.updateOrc(22, 22, 22, 22, 22, 22, 22, 22000);
//     }

//     function testTravel() external {
//         uint256[] memory ids = new uint256[](1);
//         ids[0] = 22;

//         zug.mint(address(this), 100);

//         castleMain.travel(ids, new uint256[](0), 100, 0);
//     }      

//     function testTravelAndBack() external {
//          uint256[] memory ids = new uint256[](1);
//         ids[0] = 22;

//         zug.mint(address(this), 100);

//         castleMain.travel(ids, new uint256[](0), 100, 0);

//         printOrc(orcsPoly, 22);
//         assertEq(pzug.balanceOf(address(this)), 100);

//         orcsPoly.updateOrc(22, 44, 44, 44, 44, 44, 20, 44000);

//         castlePoly.travel(ids, new uint256[](0), 100, 0);

//         printOrc(orcsMain, 22);
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


//     function printOrc(Rinkorc orcs, uint256 id_) internal {
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