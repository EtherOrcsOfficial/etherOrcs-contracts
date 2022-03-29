// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract Rescuer {

    address public admin;

    constructor() { admin = msg.sender; }

    function rescue(address orcish, address add, uint256[] calldata ids) external {
        IOrcishLike(orcish).pull(add, ids);
    }

    function pullCallback(address owner, uint256[] calldata ids) external {
        for (uint256 i = 0; i < ids.length; i++) {   
            IERC721(msg.sender).transferFrom(address(this), admin, ids[i]);
        }
    }
    
}

interface IOrcishLike {
    function pull(address owner_, uint256[] calldata ids) external;
}

interface IERC721 {
    function transfer(address to_, uint256 id) external returns(bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
}
