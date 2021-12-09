// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../ERC20.sol";
import "./ERC721.sol"; 

interface CastleLike {
    function pullCallback(address owner, uint256[] calldata ids) external;
}

interface MetadataHandlerLike {
    function getTokenURI(uint16 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier) external view returns (string memory);
}

contract EtherOrcsAllies is ERC721 {

    uint256 constant startId = 5050;

    mapping(uint256 => Ally) public allies;
    mapping(address => bool) public auth;

    uint16 shSupply;
    uint16 ogSupply;
    uint16 mgSupply;
    uint16 rgSupply;

    ERC20 boneShards;

    MetadataHandlerLike metadaHandler;

    address castle;
    bytes32 internal entropySauce;

    struct Ally {uint8 class; uint16 level; uint32 lvlProgress; uint16 modF; uint8 skillCredits; bytes22 details;}

    struct Shaman {uint8 body; uint8 featA; uint8 featB; uint8 helm; uint8 mainhand; uint8 offhand;}

    modifier noCheaters() {
        uint256 size = 0;
        address acc = msg.sender;
        assembly { size := extcodesize(acc)}

        require(auth[msg.sender] || (msg.sender == tx.origin && size == 0), "you're trying to cheat!");
        _;

        // We'll use the last caller hash to add entropy to next caller
        entropySauce = keccak256(abi.encodePacked(acc, block.coinbase));
    }

    function initialize(address ct, address bs, address meta) external {
        require(msg.sender == admin);

        castle = ct;
        boneShards = ERC20(bs);
        metadaHandler = MetadataHandlerLike(meta);
    }

    function tokenURI(uint256 id) external view returns(string memory) {
        // Shaman memory orc = shamans[id];
        // return metadaHandler.getTokenURI(uint16(id), orc.body, orc.helm, orc.mainhand, orc.offhand, orc.level, orc.zugModifier);
    }

    function mintShaman(uint256 amount) external {
        for (uint256 i = 0; i < amount; i++) {
            mintShaman();
        }
    }

    function mintShaman() public noCheaters {
        boneShards.burn(msg.sender, 60 ether);

        _mintShaman(_rand());
    } 

    function pull(address owner_, uint256[] calldata ids) external {
        require (msg.sender == castle, "not castle");
        for (uint256 index = 0; index < ids.length; index++) {
            _transfer(owner_, msg.sender, ids[index]);
        }
        CastleLike(msg.sender).pullCallback(owner_, ids);
    }

    function adjustAlly(uint256 id, uint8 class_, uint16 level_, uint32 lvlProgress_, uint16 modF_, uint8 skillCredits_, bytes22 details_) external {
        require(auth[msg.sender], "not authorized");

        allies[id] = Ally({class: class_, level: level_, lvlProgress: lvlProgress_, modF: modF_, skillCredits: skillCredits_, details: details_});
    }

    function _mintShaman(uint256 rand) internal returns (uint16 id) {
        id = uint16(shSupply + 1 + startId); //check that supply is less than 3000
        require(shSupply++ <= 3000, "max supply reached");

        // Getting Random traits
        uint8 body = _getBody(_randomize(rand, "BODY", id));

        uint8 featB    = uint8(_randomize(rand, "featB",     id) % 22) + 1; 
        uint8 featA    = uint8(_randomize(rand, "featA",    id) % 20) + 1; 
        uint8 helm     = uint8(_randomize(rand, "HELM",     id) %  7) + 1;
        uint8 mainhand = uint8(_randomize(rand, "MAINHAND", id) %  7) + 1; 
        uint8 offhand  = uint8(_randomize(rand, "OFFHAND",  id) %  7) + 1;

        _mint(msg.sender, id);

        allies[id] = Ally({class: 1, level: 25, lvlProgress: 25000, modF: 0, skillCredits: 100, details: bytes22(abi.encodePacked(body, featA, featB, helm, mainhand, offhand))});
    }

    function _getBody(uint256 rand) internal pure returns (uint8) {
        uint256 sixtyFivePct = type(uint16).max / 100 * 65;
        uint256 nineSevenPct = type(uint16).max / 100 * 97;
        uint256 nineNinePct  = type(uint16).max / 100 * 99;

        if (uint16(rand) < sixtyFivePct) return uint8(rand % 5) + 1;
        if (uint16(rand) < nineSevenPct) return uint8(rand % 4) + 6;
        if (uint16(rand) < nineNinePct) return 10;
        return 11;
    } 

    /// @dev Create a bit more of randomness
    function _randomize(uint256 rand, string memory val, uint256 spicy) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(rand, val, spicy)));
    }

    function _rand() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.basefee, block.timestamp, entropySauce)));
    }
}