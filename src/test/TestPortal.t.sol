// // SPDX-License-Identifier: Unlicense
// pragma solidity 0.8.7;

// import "ds-test/test.sol";

// import "../testnet/Rinkorc.sol";

// import "../mainnet/MainlandPortal.sol";

// import "../polygon/PolylandPortal.sol";

// import "../Castle.sol";
// import "../ERC20.sol";

// import "../BoneShards.sol";

// import "./mocks/Mocks.sol";

// contract TestPortal is DSTest {

//     Rinkorc orcsMainnet;
//     Rinkorc orcsPoly;
//     Castle  castleMainnet;
//     Castle  castlePolygon;
    
//     ERC20   zug;
//     ERC20   pzug;
    
//     BoneShards shr;
//     BoneShards pShr;

//     MainlandPortal mainPortal;
//     PolylandPortal polyPortal;

//     MockFxRoot fxRoot;

//     function setUp() external {
//         orcsMainnet = new Rinkorc();
//         orcsPoly    = new Rinkorc();

//         zug  = new ERC20();
//         pzug = new ERC20();

//         shr = new BoneShards();
//         pShr = new BoneShards();

//         castleMainnet = new Castle();
//         castlePolygon = new Castle();

//         mainPortal = new MainlandPortal();
//         polyPortal = new PolylandPortal();

//         fxRoot = new MockFxRoot();

//         // Init Portals
//         mainPortal.initialize(address(fxRoot), address(1), address(polyPortal));
//         polyPortal.initialize(address(fxRoot), address(mainPortal));

//         address[] memory adds = new address[](1);
//         adds[0] = address(castleMainnet);
//         mainPortal.setAuth(adds, true);

//         adds[0] = address(castlePolygon);
//         polyPortal.setAuth(adds, true);

//         // Init Castles
//         castleMainnet.initialize(address(mainPortal), address(orcsMainnet), address(zug), address(zug));
//         castlePolygon.initialize(address(polyPortal), address(orcsPoly), address(pzug), address(pzug));

//         // Set reflectons
//         castleMainnet.setReflection(address(castleMainnet), address(castlePolygon));
//         castleMainnet.setReflection(address(orcsMainnet), address(orcsPoly));
//         castleMainnet.setReflection(address(zug), address(pzug));

//         castlePolygon.setReflection(address(castlePolygon), address(castleMainnet));
//         castlePolygon.setReflection(address(orcsPoly), address(orcsMainnet));
//         castlePolygon.setReflection(address(pzug), address(zug));

//         // Set zug
//         orcsMainnet.setZug(address(zug));
//         zug.setMinter(address(orcsMainnet), true);
//         zug.setMinter(address(castleMainnet), true);

//         orcsMainnet.setCastle(address(castleMainnet));

//         // Set zug
//         orcsPoly.setZug(address(pzug));
//         pzug.setMinter(address(orcsPoly), true);
//         pzug.setMinter(address(castlePolygon), true);

//         orcsPoly.setCastle(address(castlePolygon));
//         address(orcsPoly).call(abi.encodeWithSignature("setAuth(address,bool)", address(castlePolygon), true));

//         zug.setMinter(address(this), true);
//         pzug.setMinter(address(this), true);

//         orcsMainnet.initMint(address(orcsMainnet), 1, 5051);
//         orcsPoly.initMint(address(castlePolygon), 1, 5051);

//         orcsMainnet.takeOrc(22);
//         orcsMainnet.updateOrc(22, 22, 22, 22, 22, 22, 22, 22000);
//     }

//     function testTravel() external {
//         uint256[] memory ids = new uint256[](1);
//         ids[0] = 22;

//         zug.mint(address(this), 100);

//         castleMainnet.travel(ids, new uint256[](0), 100, 0);

//         fail();

//     }
// }