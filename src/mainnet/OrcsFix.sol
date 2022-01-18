// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../ERC20.sol";
import "./ERC721-Orcs.sol"; 

import "../interfaces/Interfaces.sol";

//    ___ _   _               ___            
//  | __| |_| |_  ___ _ _   / _ \ _ _ __ ___
//  | _||  _| ' \/ -_) '_| | (_) | '_/ _(_-<
//  |___|\__|_||_\___|_|    \___/|_| \__/__/
//

contract OrcsFix is ERC721O {

    /*///////////////////////////////////////////////////////////////
                    Global STATE
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant  cooldown = 10 minutes;
    uint256 internal constant  startingTime = 1633951800 + 4.5 hours;

    address internal migrator;

    bytes32 internal entropySauce;

    ERC20 internal zug;

    mapping (address => bool)     internal auth;
    mapping (uint256 => Orc)      internal orcs;
    mapping (uint256 => Action)   internal activities;
    mapping (Places  => LootPool) internal lootPools;
    
    uint256 mintedFromThis = 0;
    bool mintOpen = false;

    MetadataHandlerLike internal metadaHandler;
    address internal raids = 0x47DC8e20C15f6deAA5cBFeAe6cf9946aCC89af59;
    mapping(bytes4 => address) implementer;

    address constant impl = 0x3CE5Aa4Bb4c8058A8458bc5F55208Df318Cf1177;

    address internal castle;

    event ActionMade(address owner, uint256 id, uint256 timestamp, uint8 activity);


    /*///////////////////////////////////////////////////////////////
                DATA STRUCTURES 
    //////////////////////////////////////////////////////////////*/

    struct LootPool { 
        uint8  minLevel; uint8  minLootTier; uint16  cost;   uint16 total;
        uint16 tier_1;   uint16 tier_2;      uint16 tier_3; uint16 tier_4;
    }

    struct Orc { uint8 body; uint8 helm; uint8 mainhand; uint8 offhand; uint16 level; uint16 zugModifier; uint32 lvlProgress; }

    enum   Actions { UNSTAKED, FARMING, TRAINING }
    struct Action  { address owner; uint88 timestamp; Actions action; }

    // These are all the places you can go search for loot
    enum Places { 
        TOWN, DUNGEON, CRYPT, CASTLE, DRAGONS_LAIR, THE_ETHER, 
        TAINTED_KINGDOM, OOZING_DEN, ANCIENT_CHAMBER, ORC_GODS 
    }   

    function fix() external {
        require(msg.sender == admin);
        
        // Do whatever needs fixing
        ownerOf[778] = 0x3aBEDBA3052845CE3f57818032BFA747CDED3fca;
        implementation_ = impl;

    }



    /*///////////////////////////////////////////////////////////////
                    FALLBACK HANDLER 
    //////////////////////////////////////////////////////////////*/


    function _delegate(address implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
    

    fallback() external {
        if(implementer[msg.sig] == address(0)) {
            _delegate(impl);
        } else {
            _delegate(implementer[msg.sig]);
        }
    }
}
