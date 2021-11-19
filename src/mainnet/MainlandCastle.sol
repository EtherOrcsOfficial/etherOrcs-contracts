// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

/// @dev A simple contract to orchestrate comings and going from the OrcsPortal
contract MainlandCastle {

    address mainlandPortal;
    address orcs;
    address zug;
    address shr;

    mapping (address => address) reflection;

    /// @dev Send Orcs, allies and tokens to PolyLand
    function travel(uint256[] calldata orcsIds, uint256[] calldata alliesIds, uint256 zugAmount, uint256 shrAmount) external {
        address target = reflection[address(this)];

        bytes[] memory calls = new bytes[](orcsIds.length + alliesIds.length + (zugAmount > 0 ? 1 : 0) + (shrAmount > 0 ? 1 : 0));

        // Send Orcs here and create call to mint
        

        // Send allies here and create call to mint

        if (zugAmount > 0) {
            ERC20Like(zug).burn(msg.sender, zugAmount);
            calls[orcsIds.length + alliesIds.length] = abi.encodeWithSelector(this.mintToken.selector, reflection[address(zug)], msg.sender, zugAmount);
        }

        if (shrAmount > 0) {
            ERC20Like(shr).burn(msg.sender, shrAmount);
            calls[orcsIds.length + alliesIds.length] = abi.encodeWithSelector(this.mintToken.selector, reflection[address(shr)], msg.sender, shrAmount);
        }

        PortalLike(mainlandPortal).sendMessage(abi.encode(target, calls));
    }

    function receiveOrc(address owner, uint256 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint16 lvlProgress) external {
        _onlyPortal();

        EtherOrcsLike _orcs = EtherOrcsLike(orcs);

        _orcs.manuallyAdjustOrc(id, body, helm, mainhand, offhand, level, zugModifier, lvlProgress);
        _orcs.transfer(owner, id);
    }

    function mintToken(address token, address to, uint256 amount) external { 
        _onlyPortal();

        ERC20Like(token).mint(to, amount);
    }

    function _onlyPortal() view internal {
        require(msg.sender == mainlandPortal, "not portal");
    } 

}

interface EtherOrcsLike {
    function manuallyAdjustOrc(uint256 id, uint8 body, uint8 helm, uint8 mainhand, uint8 offhand, uint16 level, uint16 zugModifier, uint16 lvlProgress) external;
    function transfer(address to, uint256 tokenId) external;
}

interface PortalLike {
    function sendMessage(bytes calldata message_) external;
}

interface ERC20Like {
    function burn(address from, uint256 amount) external;
    function mint(address from, uint256 amount) external;
} 