// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../../ERC20.sol";
import "../../polygon/PolylandPortal.sol";

import "../../polygon/GamingOraclePoly.sol";
import "../../mainnet/MainlandPortal.sol";

contract MockERC20 is ERC20 {
    string public constant override name     = "MOCK";
    string public constant override symbol   = "MOCK";
    uint8  public constant override decimals = 18;
}

contract MockHall {
    mapping (uint256 => uint256) public  joined;

    function setJoined(uint256 id, uint256 time) public {
        joined[id] = time;
    }
}

interface PortalLikesish {
    function processMessageFromRoot(uint256 stateId, address rootMessageSender, bytes calldata data) external;
    function receiveMessage(bytes memory data) external;
}

contract MockFxRoot {


    function sendMessageToChild(address child, bytes calldata data) external {
        PortalLikesish(child).processMessageFromRoot(1, msg.sender, data);
    }

    function sendMessageToRoot(address root, bytes calldata data) external {
        PortalLikesish(root).receiveMessage(data);
    }

}

contract MockPolyPortal is PolylandPortal {

    function sendMessage(bytes calldata message_) override external {
        require(auth[msg.sender], "not authorized to use portal");
        MockFxRoot(fxChild).sendMessageToRoot(mainlandPortal,message_);
        emit MessageSent(message_);
    }

}

contract MockMainPortal is MainlandPortal {

    function receiveMessage(bytes calldata inputData) public override {
        _processMessageFromChild(inputData);
    }
}


contract MockGamingOracle is GamingOraclePoly {

     function request() external override returns (uint64 key){
        require(auth[msg.sender], "not authorized");
        
        key = uint64(uint256(keccak256(abi.encodePacked(msg.sender, salts[msg.sender]++))));
        
        bytes32 id = keccak256(abi.encodePacked(key, msg.sender));
        keys[key] = id;
        rands[keys[key]] = uint256(1); // 
    }

}