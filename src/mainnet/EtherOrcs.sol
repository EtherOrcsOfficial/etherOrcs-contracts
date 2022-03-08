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

contract EtherOrcs is ERC721O {

    /*///////////////////////////////////////////////////////////////
                    Global STATE
    //////////////////////////////////////////////////////////////*/

    uint256 public constant  cooldown = 10 minutes;
    uint256 public constant  startingTime = 1633951800 + 4.5 hours;

    address public migrator;

    bytes32 internal entropySauce;

    ERC20 public zug;

    mapping (address => bool)     public auth;
    mapping (uint256 => Orc)      public orcs;
    mapping (uint256 => Action)   public activities;
    mapping (Places  => LootPool) public lootPools;
    
    uint256 mintedFromThis = 0;
    bool mintOpen = false;

    MetadataHandlerLike public metadaHandler;
    address public raids = 0x47DC8e20C15f6deAA5cBFeAe6cf9946aCC89af59;
    mapping(bytes4 => address) implementer;

    address constant impl = 0x7d98439fD9b5989D0897124A977869d9a678Ec85;

    address public castle;

    function setImplementer(bytes4[] calldata funcs, address source) external onlyOwner {
        for (uint256 index = 0; index < funcs.length; index++) {
            implementer[funcs[index]] = source; 
        }
    }

    function tokenURI(uint256 id) external view returns(string memory) {
        Orc memory orc = orcs[id];
        return metadaHandler.getTokenURI(uint16(id), orc.body, orc.helm, orc.mainhand, orc.offhand, orc.level, orc.zugModifier);
    }

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

    /*///////////////////////////////////////////////////////////////
                    MODIFIERS 
    //////////////////////////////////////////////////////////////*/

    modifier noCheaters() {
        uint256 size = 0;
        address acc = msg.sender;
        assembly { size := extcodesize(acc)}

        require(auth[msg.sender] || (msg.sender == tx.origin && size == 0), "you're trying to cheat!");
        _;

        // We'll use the last caller hash to add entropy to next caller
        entropySauce = keccak256(abi.encodePacked(acc, block.coinbase));
    }

    modifier ownerOfOrc(uint256 id, address who_) { 
        require(ownerOf[id] == who_ || activities[id].owner == who_, "not your orc");
        _;
    }

    modifier isOwnerOfOrc(uint256 id) {
         require(ownerOf[id] == msg.sender || activities[id].owner == msg.sender, "not your orc");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == admin);
        _;
    }


    /*///////////////////////////////////////////////////////////////
                    PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function doAction(uint256 id, Actions action_) public ownerOfOrc(id, msg.sender) noCheaters {
       _doAction(id, msg.sender, action_, msg.sender);
    }

    function _doAction(uint256 id, address orcOwner, Actions action_, address who_) internal ownerOfOrc(id, who_) {
        Action memory action = activities[id];
        require(action.action != action_, "already doing that");

        // Picking the largest value between block.timestamp, action.timestamp and startingTime
        uint88 timestamp = uint88(block.timestamp > action.timestamp ? block.timestamp : action.timestamp);

        if (action.action == Actions.UNSTAKED)  _transfer(orcOwner, address(this), id);
     
        else {
            if (block.timestamp > action.timestamp) _claim(id);
            timestamp = timestamp > action.timestamp ? timestamp : action.timestamp;
        }

        address owner_ = action_ == Actions.UNSTAKED ? address(0) : orcOwner;
        if (action_ == Actions.UNSTAKED) _transfer(address(this), orcOwner, id);

        activities[id] = Action({owner: owner_, action: action_,timestamp: timestamp});
        emit ActionMade(orcOwner, id, block.timestamp, uint8(action_));
    }


    function doActionWithManyOrcs(uint256[] calldata ids, Actions action_) external {
        for (uint256 index = 0; index < ids.length; index++) {
            _doAction(ids[index], msg.sender, action_, msg.sender);
        }
    }

    function pillageWithManyOrcs(uint256[] calldata ids, Places place, bool tryHelm, bool tryMainhand, bool tryOffhand) external {
        for (uint256 index = 0; index < ids.length; index++) {
            pillage(ids[index], place, tryHelm, tryMainhand,tryOffhand);
        }
    }

    function claim(uint256[] calldata ids) external {
        for (uint256 index = 0; index < ids.length; index++) {
            _claim(ids[index]);
        }
    }

    function _claim(uint256 id) internal noCheaters {
        Orc    memory orc    = orcs[id];
        Action memory action = activities[id];

        if(block.timestamp <= action.timestamp) return;

        uint256 timeDiff = uint256(block.timestamp - action.timestamp);

        if (action.action == Actions.FARMING) zug.mint(action.owner, claimableZug(timeDiff, orc.zugModifier));
       
        if (action.action == Actions.TRAINING) {
            if (orcs[id].level > 0 && orcs[id].lvlProgress < 1000){
                orcs[id].lvlProgress = (1000 * orcs[id].level) + orcs[id].lvlProgress;
            }
            orcs[id].lvlProgress += uint32(timeDiff * 3000 / 1 days);
            orcs[id].level       = uint16(orcs[id].lvlProgress / 1000);
        }

        activities[id].timestamp = uint88(block.timestamp);
    }

    function pillage(uint256 id, Places place, bool tryHelm, bool tryMainhand, bool tryOffhand) public isOwnerOfOrc(id) noCheaters {
        require(block.timestamp >= uint256(activities[id].timestamp), "on cooldown");
        require(place != Places.ORC_GODS,  "You can't pillage the Orc God");
        require(_tier(orcs[id].mainhand) < 10);

        if(activities[id].timestamp < block.timestamp) _claim(id); // Need to claim to not have equipment reatroactively multiplying

        uint256 rand_ = _rand();
  
        LootPool memory pool = lootPools[place];
        require(orcs[id].level >= uint16(pool.minLevel), "below minimum level");

        if (pool.cost > 0) {
            zug.burn(msg.sender, uint256(pool.cost) * 1 ether);
        } 
        {
        uint8 item;
        if (tryHelm) {
            ( pool, item ) = _getItemFromPool(pool, _randomize(rand_,"HELM", id));
            if (item != 0 ) orcs[id].helm = item;
        }
        if (tryMainhand) {
            ( pool, item ) = _getItemFromPool(pool, _randomize(rand_,"MAINHAND", id));
            if (item != 0 ) orcs[id].mainhand = item;
        }
        if (tryOffhand) {
            ( pool, item ) = _getItemFromPool(pool, _randomize(rand_,"OFFHAND", id));
            if (item != 0 ) orcs[id].offhand = item;
        }

        if (uint(place) > 1) lootPools[place] = pool;
        }

        // Update zug modifier
        Orc memory orc = orcs[id];
        uint16 zugModifier_ = _tier(orc.helm) + _tier(orc.mainhand) + _tier(orc.offhand);

        orcs[id].zugModifier = zugModifier_;

        activities[id].timestamp = uint88(block.timestamp + cooldown);
    } 

    function sendToRaid(uint256[] calldata ids, uint8 location_, bool double_) external noCheaters { 
        require(address(raids) != address(0), "raids not set");
        for (uint256 index = 0; index < ids.length; index++) {
            if (activities[ids[index]].action != Actions.UNSTAKED) _doAction(ids[index], msg.sender, Actions.UNSTAKED, msg.sender);
            _transfer(msg.sender, raids, ids[index]);
        }
        RaidsLike(raids).stakeManyAndStartCampaign(ids, msg.sender, location_, double_);
    }

    function startRaidCampaign(uint256[] calldata ids, uint8 location_, bool double_) external noCheaters { 
        require(address(raids) != address(0), "raids not set");
        for (uint256 index = 0; index < ids.length; index++) {
            require(msg.sender == RaidsLike(raids).commanders(ids[index]) && ownerOf[ids[index]] == address(raids), "not staked or not your orc");
        }
        RaidsLike(raids).startCampaignWithMany(ids, location_, double_);
    }

    function returnFromRaid(uint256[] calldata ids, Actions action_) external noCheaters { 
        RaidsLike raidsContract = RaidsLike(raids);
        for (uint256 index = 0; index < ids.length; index++) {
            require(msg.sender == raidsContract.commanders(ids[index]), "not your orc");
            raidsContract.unstake(ids[index]);
            if (action_ != Actions.UNSTAKED) _doAction(ids[index], msg.sender, action_, msg.sender);
        }
    }

    function pull(address owner_, uint256[] calldata ids) external {
        require (auth[msg.sender], "not auth");
        for (uint256 index = 0; index < ids.length; index++) {
            if (activities[ids[index]].action != Actions.UNSTAKED) _doAction(ids[index], owner_, Actions.UNSTAKED, owner_);
            _transfer(owner_, msg.sender, ids[index]);
        }
        CastleLike(msg.sender).pullCallback(owner_, ids);
    }

    function manuallyAdjustOrc(uint256 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint32 lvlProgress) external {
        require(msg.sender == admin || auth[msg.sender], "not authorized");
        orcs[id].body = body;
        orcs[id].helm = helm;
        orcs[id].mainhand = mainhand;
        orcs[id].offhand = offhand;
        orcs[id].level = level;
        orcs[id].lvlProgress = lvlProgress;
        orcs[id].zugModifier = zugModifier;
    }

    function setAuth(address add, bool status) external {
        require(msg.sender == admin);
        auth[add] = status;
    }

    /*///////////////////////////////////////////////////////////////
                    VIEWERS
    //////////////////////////////////////////////////////////////*/

    function claimable(uint256 id) external view returns (uint256 amount) {
        uint256 timeDiff = block.timestamp > activities[id].timestamp ? uint256(block.timestamp - activities[id].timestamp) : 0;
        amount = activities[id].action == Actions.FARMING ? claimableZug(timeDiff, orcs[id].zugModifier) : timeDiff * 3000 / 1 days;
    }

    /*///////////////////////////////////////////////////////////////
                    INTERNAL  HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @dev take an available item from a pool
    function _getItemFromPool(LootPool memory pool, uint256 rand) internal pure returns (LootPool memory, uint8 item) {
        uint draw = rand % pool.total--; 

        if (draw > pool.tier_1 + pool.tier_2 + pool.tier_3 && pool.tier_4-- > 0) {
            item = uint8((draw % 4 + 1) + (pool.minLootTier + 3) * 4);     
            return (pool, item);
        }

        if (draw > pool.tier_1 + pool.tier_2 && pool.tier_3-- > 0) {
            item = uint8((draw % 4 + 1) + (pool.minLootTier + 2) * 4);
            return (pool, item);
        }

        if (draw > pool.tier_1 && pool.tier_2-- > 0) {
            item = uint8((draw % 4 + 1) + (pool.minLootTier + 1) * 4);
            return (pool, item);
        }

        if (pool.tier_1-- > 0) {
            item = uint8((draw % 4 + 1) + pool.minLootTier * 4);
            return (pool, item);
        }
    }

    function claimableZug(uint256 timeDiff, uint16 zugModifier) internal pure returns (uint256 zugAmount) {
        zugAmount = timeDiff * (4 + zugModifier) * 1 ether / 1 days;
    }

    /// @dev Convert an id to its tier
    function _tier(uint16 id) internal pure returns (uint16) {
        if (id == 0) return 0;
        return ((id - 1) / 4 );
    }

    /// @dev Create a bit more of randomness
    function _randomize(uint256 rand, string memory val, uint256 spicy) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(rand, val, spicy)));
    }

    function _rand() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.basefee, block.timestamp, entropySauce)));
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
