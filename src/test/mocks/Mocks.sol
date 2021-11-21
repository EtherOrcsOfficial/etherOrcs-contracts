// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

interface PortalLike {
    function processMessageFromRoot(uint256 stateId, address rootMessageSender, bytes calldata data) external;
}

contract MockFxRoot {

    function sendMessageToChild(address child, bytes calldata data) external {
        PortalLike(child).processMessageFromRoot(1, msg.sender, data);
    }
}