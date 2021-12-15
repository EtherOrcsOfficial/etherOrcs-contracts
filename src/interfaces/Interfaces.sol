// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

interface OrcishLike {
    function pull(address owner, uint256[] calldata ids) external;
    function manuallyAdjustOrc(uint256 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint32 lvlProgress) external;
    function transfer(address to, uint256 tokenId) external;
    function orcs(uint256 id) external view returns(uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint32 lvlProgress);
    function allies(uint256 id) external view returns (uint8 class, uint16 level, uint32 lvlProgress, uint16 modF, uint8 skillCredits, bytes22 details);
    function adjustAlly(uint256 id, uint8 class_, uint16 level_, uint32 lvlProgress_, uint16 modF_, uint8 skillCredits_, bytes22 details_) external;
}

interface PortalLike {
    function sendMessage(bytes calldata message_) external;
}

interface OracleLike {
    function request() external returns (uint64 key);
    function getRandom(uint64 id) external view returns(uint256 rand);
}

interface MetadataHandlerLike {
    function getTokenURI(uint16 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier) external view returns (string memory);
}

interface MetadataHandlerAllies {
    function getTokenURI(uint256 id_, uint256 class_, uint256 level_, uint256 modF_, uint256 skillCredits_, bytes22 details_) external view returns (string memory);
}

interface RaidsLike {
    function stakeManyAndStartCampaign(uint256[] calldata ids_, address owner_, uint256 location_, bool double_) external;
    function startCampaignWithMany(uint256[] calldata ids, uint256 location_, bool double_) external;
    function commanders(uint256 id) external returns(address);
    function unstake(uint256 id) external;
}

interface RaidsLikePoly {
    function stakeManyAndStartCampaign(uint256[] calldata ids_, address owner_, uint256 location_, bool double_, uint256[] calldata potions_) external;
    function startCampaignWithMany(uint256[] calldata ids, uint256 location_, bool double_,  uint256[] calldata potions_) external;
    function commanders(uint256 id) external returns(address);
    function unstake(uint256 id) external;
}

interface CastleLike {
    function pullCallback(address owner, uint256[] calldata ids) external;
}

interface EtherOrcsLike {
    function ownerOf(uint256 id) external view returns (address owner_);
    function activities(uint256 id) external view returns (address owner, uint88 timestamp, uint8 action);
    function orcs(uint256 orcId) external view returns (uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint32 lvlProgress);
}

interface ERC20Like {
    function balanceOf(address from) external view returns(uint256 balance);
    function burn(address from, uint256 amount) external;
    function mint(address from, uint256 amount) external;
    function transfer(address to, uint256 amount) external;
}

interface ERC1155Like {
    function mint(address to, uint256 id, uint256 amount) external;
    function burn(address from, uint256 id, uint256 amount) external;
}

interface ERC721Like {
    function transferFrom(address from, address to, uint256 id) external;   
    function transfer(address to, uint256 id) external;
    function ownerOf(uint256 id) external returns (address owner);
    function mint(address to, uint256 tokenid) external;
}

interface HallOfChampionsLike {
    function joined(uint256 orcId) external view returns (uint256 joinDate);
} 

interface AlliesLike {
    function allies(uint256 id) external view returns (uint8 class, uint16 level, uint32 lvlProgress, uint16 modF, uint8 skillCredits, bytes22 details);
}
