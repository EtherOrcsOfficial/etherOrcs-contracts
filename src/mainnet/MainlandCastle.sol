// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

/// @dev A simple contract to orchestrate comings and going from the OrcsPortal
contract MainlandCastle {

    address mainlandPortal;
    address allies;
    address orcs;
    address zug;
    address shr;

    mapping (address => address) reflection;
    mapping (uint256 => address) orcOwner;
    mapping (uint256 => address) allyOwner;

    /// @dev Send Orcs, allies and tokens to PolyLand
    function travel(uint256[] calldata orcIds, uint256[] calldata allyIds, uint256 zugAmount, uint256 shrAmount) external {
        address target = reflection[address(this)];

        bytes[] memory calls = new bytes[](orcIds.length + allyIds.length + (zugAmount > 0 ? 1 : 0) + (shrAmount > 0 ? 1 : 0));

        if (orcIds.length > 0) {
            _pullIds(orcs, orcIds);

            // This will create orcs exactly as they exist in this chain
            for (uint256 i = 0; i < orcIds.length; i++) {
                (uint8 b, uint8 h, uint8 m, uint8 o, uint16 l, uint16 zM, uint32 lP) = OrcishLike(orcs).orcs(orcIds[i]);
                calls[i] = abi.encodeWithSelector(this.callOrcs.selector, abi.encodeWithSelector(OrcishLike.manuallyAdjustOrc.selector, b, h, m, o, l, zM, lP));
            }

            calls[orcIds.length] = abi.encodeWithSelector(this.unstakeMany.selector, msg.sender,  orcIds);
        }

        if (zugAmount > 0) {
            ERC20Like(zug).burn(msg.sender, zugAmount);
            calls[orcIds.length + allyIds.length] = abi.encodeWithSelector(this.mintToken.selector, reflection[address(zug)], msg.sender, zugAmount);
        }

        if (shrAmount > 0) {
            ERC20Like(shr).burn(msg.sender, shrAmount);
            calls[orcIds.length + allyIds.length] = abi.encodeWithSelector(this.mintToken.selector, reflection[address(shr)], msg.sender, shrAmount);
        }

        PortalLike(mainlandPortal).sendMessage(abi.encode(target, calls));
    }

    function callOrcs(bytes calldata data) external {
        _onlyPortal();

        (bool succ, ) = orcs.call(data);
        require(succ);
    }

    function unstakeMany(address token, address owner, uint256[] calldata ids) external {
        _onlyPortal();

        for (uint256 i = 0; i < ids.length; i++) {
            if (token == orcs)   delete orcOwner[ids[i]];
            if (token == allies) delete allyOwner[ids[i]];
        }

        ERC721Like(token).batchTransfer(owner, ids);
    }

    function mintToken(address token, address to, uint256 amount) external { 
        _onlyPortal();

        ERC20Like(token).mint(to, amount);
    }

    function _pullIds(address token, uint256[] calldata ids) internal {
        // The ownership will be checked to the token contract
        OrcishLike(token).pull(msg.sender, ids);
    }

    function pullCallback(address token, address owner, uint256[] calldata ids) external {
        require(msg.sender == orcs || msg.sender == allies);
        for (uint256 i = 0; i < ids.length; i++) {
            _stake(token, ids[i], owner);
        }
    }

    function _stake(address token, uint256 id, address owner) internal {
        require((token == orcs ? orcOwner[id] : allyOwner[id]) == address(0), "already staked");
        require(msg.sender == token, "not orcs contract");
        require(ERC721Like(token).ownerOf(id) == address(this), "orc not transferred");

        if (token == orcs)   orcOwner[id]  = owner;
        if (token == allies) allyOwner[id] = owner;
    }

    function _onlyPortal() view internal {
        require(msg.sender == mainlandPortal, "not portal");
    } 

}

interface OrcishLike {
    function pull(address owner, uint256[] calldata ids) external;
    function manuallyAdjustOrc(uint256 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint16 lvlProgress) external;
    function transfer(address to, uint256 tokenId) external;
    function orcs(uint256 id) external view returns(uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint32 lvlProgress);
}

interface PortalLike {
    function sendMessage(bytes calldata message_) external;
}

interface ERC20Like {
    function burn(address from, uint256 amount) external;
    function mint(address from, uint256 amount) external;
} 

interface ERC721Like {
    function ownerOf(uint256 id) external returns (address owner);
    function batchTransfer(address to, uint256[] calldata tokenids) external;
}