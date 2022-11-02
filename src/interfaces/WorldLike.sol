// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

interface WorldLike {
    function locationForStakedEntity(uint256 _tokenId) external view returns(uint8);

    function ownerForStakedEntity(uint256 _tokenId) external view returns(address);

    function balanceOf(address _owner) external view returns (uint256);

    function adminTransferEntityOutOfWorld(
        address _originalOwner,
        uint16 _tokenId)
    external;
}

// Do not use. Otherwise, anytime a new location was added, we would need to upgrade the old contracts with the new enum value.
// Instead, we'll look at the raw uint8.
//
// enum Location {
//     NOT_STAKED,
//     ACTIVE_FARMING
// }