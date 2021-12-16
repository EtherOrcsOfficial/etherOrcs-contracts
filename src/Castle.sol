// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "./interfaces/Interfaces.sol";

/// @dev A simple contract to orchestrate comings and going from the OrcsPortal
contract Castle {

    address implementation_;
    address public admin;
    
    address public portal;
    address public allies;
    address public orcs;
    address public zug;
    address public shr;

    mapping (address => address) public reflection;
    mapping (uint256 => address) public orcOwner;
    mapping (uint256 => address) public allyOwner;

    function initialize(address portal_, address orc_, address zug_, address shr_) external {
        require(msg.sender == admin);
        portal = portal_;
        orcs   = orc_;
        zug = zug_;
        shr = shr_;
    }

    function setAllies(address a_) external {
        require(msg.sender == admin);
        allies = a_;
    }

    function setReflection(address key_, address reflection_) external {
        require(msg.sender == admin);
        reflection[key_] = reflection_;
        reflection[reflection_] = key_;
    }

    /// @dev Send Orcs, allies and tokens to PolyLand
    function travel(uint256[] calldata orcIds, uint256[] calldata alliesIds, uint256 zugAmount, uint256 shrAmount) external {
        address target = reflection[address(this)];

        uint256 orcsLen   = orcIds.length;
        uint256 allieslen = alliesIds.length;
        uint256 currIndex = 0;

        bytes[] memory calls = new bytes[]((orcsLen > 0 ? orcsLen + 1 : 0) + (allieslen > 0 ? allieslen + 1 : 0) + (zugAmount > 0 ? 1 : 0) + (shrAmount > 0 ? 1 : 0));


        if (orcsLen > 0) {
            _pullIds(orcs, orcIds);

            // This will create orcs exactly as they exist in this chain
            for (uint256 i = 0; i < orcIds.length; i++) {
                calls[i] = _buildData(orcIds[i]);
            }

            calls[orcsLen] = abi.encodeWithSelector(this.unstakeMany.selector,reflection[orcs], msg.sender,  orcIds);
            currIndex += orcsLen + 1;
        }

        if (allieslen > 0) {
            _pullIds(allies, alliesIds);

            // This will create orcs exactly as they exist in this chain
            for (uint256 i = 0; i < alliesIds.length; i++) {
                calls[currIndex + i] = _buildDataAllies(alliesIds[i]);
            }

            calls[currIndex + allieslen] = abi.encodeWithSelector(this.unstakeMany.selector, reflection[allies], msg.sender,  alliesIds);
            currIndex = currIndex + allieslen + 1;
        }

        if (zugAmount > 0) {
            ERC20Like(zug).burn(msg.sender, zugAmount);
            calls[currIndex] = abi.encodeWithSelector(this.mintToken.selector, reflection[address(zug)], msg.sender, zugAmount);
            currIndex++;
        }

        if (shrAmount > 0) {
            ERC20Like(shr).burn(msg.sender, shrAmount);
            calls[currIndex] = abi.encodeWithSelector(this.mintToken.selector, reflection[address(shr)], msg.sender, shrAmount);
        }

        PortalLike(portal).sendMessage(abi.encode(target, calls));
    }

    function callOrcs(bytes calldata data) external {
        _onlyPortal();

        (bool succ, ) = orcs.call(data);
        require(succ);
    }

    event D(uint tt);
    event DAD(address al);
    function callAllies(bytes calldata data) external {
        _onlyPortal();
        
        (bool succ, ) = allies.call(data);
        require(succ);
    }

    function unstakeMany(address token, address owner, uint256[] calldata ids) external {
        _onlyPortal();

        emit DAD(token);

        for (uint256 i = 0; i < ids.length; i++) {  
            emit D(ids[i]);
            if (token == orcs)   delete orcOwner[ids[i]];
            if (token == allies) delete allyOwner[ids[i]];
            ERC721Like(token).transfer(owner, ids[i]);
        }
    }

    function mintToken(address token, address to, uint256 amount) external { 
        _onlyPortal();

        ERC20Like(token).mint(to, amount);
    }

    function _pullIds(address token, uint256[] calldata ids) internal {
        // The ownership will be checked to the token contract
        OrcishLike(token).pull(msg.sender, ids);
    }

    function pullCallback(address owner, uint256[] calldata ids) external {
        require(msg.sender == orcs || msg.sender == allies);
        for (uint256 i = 0; i < ids.length; i++) {
            _stake(msg.sender, ids[i], owner);
        }
    }

    function _buildData(uint256 id) internal view returns (bytes memory data) {
        (uint8 b, uint8 h, uint8 m, uint8 o, uint16 l, uint16 zM, uint32 lP) = OrcishLike(orcs).orcs(id);
        data = abi.encodeWithSelector(this.callOrcs.selector, abi.encodeWithSelector(OrcishLike.manuallyAdjustOrc.selector,id, b, h, m, o, l, zM, lP));   
    }

    function _buildDataAllies(uint256 id) internal view returns (bytes memory data) {
        (uint8 cl, uint16 l, uint32 lP, uint16 modF, uint8 sc, bytes22 d) = OrcishLike(allies).allies(id);
        data = abi.encodeWithSelector(this.callAllies.selector, abi.encodeWithSelector(OrcishLike.adjustAlly.selector,id,cl,l,lP,modF,sc,d));   
    }

    function _stake(address token, uint256 id, address owner) internal {
        require((token == orcs ? orcOwner[id] : allyOwner[id]) == address(0), "already staked");
        require(msg.sender == token, "not orcs contract");
        require(ERC721Like(token).ownerOf(id) == address(this), "orc not transferred");

        if (token == orcs)   orcOwner[id]  = owner;
        if (token == allies) allyOwner[id] = owner;
    }

    function _onlyPortal() view internal {
        require(msg.sender == portal, "not portal");
    } 

}