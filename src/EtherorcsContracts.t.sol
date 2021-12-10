// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./EtherorcsContracts.sol";

contract EtherorcsContractsTest is DSTest {
    EtherorcsContracts contracts;

    function setUp() public {
        contracts = new EtherorcsContracts();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
