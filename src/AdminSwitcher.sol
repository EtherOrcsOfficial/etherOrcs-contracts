// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;


contract AdminSwitcher {

    address implementation_;
    address public admin;

    function switchAdmin(address newAdmin, address newImplementation) external {
        admin = newAdmin;
        implementation_ = newImplementation;
    }

}
