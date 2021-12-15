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

//new owner 0x37060d6C4B79e2982DcEd784379338eeB5ce87f5

//admin switcher 0xdE57Df3f4c5cCc9cEb94eC5BdbFa24634C180d12

// orcs impl 0x9e6d97f06e09b8ec96bbeae3254cd9a7de873561
// castle imlp 0x8fb11E5de684Cf293bB55B12f80486Ad90876772
// raids impl 0x0F227E52Be51203c6a485DB303f7335dBb876960
// portal impl 0xBFd0cD2A209C0DfD9bA2A76Cec5fCD42e451D9Be
// hall impl 0xd570427988F152c3C89Db940Cc19C5C2F45589f1
