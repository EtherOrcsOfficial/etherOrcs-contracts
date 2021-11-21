// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "ds-test/test.sol";

import "../testnet/Rinkorc.sol";

import "../mainnet/MainlandPortal.sol";

import "../polygon/PolylandPortal.sol";

import "../Castle.sol";

import "./mocks/Mocks.sol";

contract TestPortal is DSTest {

    Rinkorc orcsMainnet;
    Rinkorc orcsPoly;
    Castle  castleMainnet;
    Castle  castlePolygon;

    MainlandPortal mainPortal;
    PolylandPortal polyPortal;

    MockFxRoot fxRoot;

    function setUp() external {
        orcsMainnet = new Rinkorc();
        orcsPoly    = new Rinkorc();

        castleMainnet = new Castle();
        castlePolygon = new Castle();

        mainPortal = new MainlandPortal();
        polyPortal = new PolylandPortal();

        fxRoot = new MockFxRoot();

        // Init Portals
        mainPortal.initialize(address(fxRoot), address(1), address(polyPortal));
        polyPortal.initialize(address(fxRoot), address(mainPortal));

        address[] memory adds = new address[](1);
        adds[0] = address(castleMainnet);
        mainPortal.setAuth(adds, true);

        adds[0] = address(castlePolygon);
        polyPortal.setAuth(adds, true);

        // Init Castles
        castleMainnet.initialize(address(mainPortal), address(orcsMainnet));
        castlePolygon.initialize(address(polyPortal), address(orcsPoly));

        // Set reflectons
        castleMainnet.setReflection(address(castleMainnet), address(castlePolygon));
        castleMainnet.setReflection(address(orcsMainnet), address(orcsPoly));

        castlePolygon.setReflection(address(castlePolygon), address(castleMainnet));
        castlePolygon.setReflection(address(orcsPoly), address(orcsMainnet));

        orcsMainnet.mint(22);
        orcsMainnet.updateOrc(22, 22, 22, 22, 22, 22, 22, 22000);
    }

    function testTravel() external {
        uint256[] memory ids = new uint256[](1);
        ids[0] = 22;

        castleMainnet.travel(ids, new uint256[](0), 0, 0);

    }


}