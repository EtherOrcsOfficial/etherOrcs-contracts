// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

interface NameHandlerLike {
    function getName(uint256 orcId) external view returns(string memory);
    function getBodyName(uint8 id) external pure returns (string memory);
    function getHelmName(uint8 id) external pure returns (string memory);
    function getMainhandName(uint8 id) external pure returns (string memory);
    function getOffhandName(uint8 id) external pure returns (string memory);
    function timeAsChampion(uint256 id) external view returns(uint256);
}

contract MetadataMiddleware  {

    address impl_;
    address public manager;

    enum Part { body, helm, mainhand, offhand, unique }

    mapping(uint8 => address) bodies;
    mapping(uint8 => address) helms;
    mapping(uint8 => address) mainhands;
    mapping(uint8 => address) offhands;
    mapping(uint8 => address) uniques;

    mapping(bytes4 => address) implementer;

    address public nameHandler;
    address public equipmentHandler;
    bool    public insertChampion;
    
    address constant impl = 0x164B9511af29BAf9095DC1deEb767E28aCa78f0c;
    
    function getTokenURI(uint16 id_, uint8 body_, uint8 helm_, uint8 mainhand_, uint8 offhand_, uint16 level_, uint16 zugModifier_) public view returns (string memory) {
        (, bytes memory ret) = address(this).staticcall(abi.encodeWithSignature("getSVG(uint8,uint8,uint8,uint8)", body_, helm_, mainhand_, offhand_));

        string memory s = abi.decode(ret, (string));
        string memory svg = BBase64.encode(bytes(s));

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    BBase64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',_getName(id_),'", "description":"EtherOrcs is a collection of 5050 Orcs ready to pillage the blockchain. With no IPFS or API, these Orcs are the very first role-playing game that takes place 100% on-chain. Spawn new Orcs, battle your Orc to level up, and pillage different loot pools to get new weapons and gear which upgrades your Orc metadata. This Horde of Orcs will stand the test of time and live on the blockchain for eternity.", "image": "',
                                'data:image/svg+xml;base64,',
                                svg,
                                '",',
                                getAttributes(id_, body_, helm_, mainhand_, offhand_, level_, zugModifier_),
                                '}'
                            )
                        )
                    )
                )
            );
    }

    function setImplementer(bytes4[] calldata funcs, address source) external {
        require(msg.sender == manager, "not manager");

        for (uint256 index = 0; index < funcs.length; index++) {
            implementer[funcs[index]] = source; 
        }
    }

    function setAddress(bytes32 param, address value) external {
        require(msg.sender == manager,"not manager");
        if(param == "nameHandler") {
            nameHandler = value;
        }
        if(param == "equipmentHandler") {
            equipmentHandler = value;
        }
    }

    function setInsertChampion(bool status) external {
        require(msg.sender == manager,"not manager");
        insertChampion = status;
    }

    function getAttributes(uint16 id_, uint8 body_, uint8 helm_, uint8 mainhand_, uint8 offhand_, uint16 level_, uint16 zugModifier_) internal view returns (string memory) {
       if (insertChampion) {
            return string(abi.encodePacked(
                '"attributes": [',
                    getBodyAttributes(body_),         ',',
                    getHelmAttributes(helm_),         ',',
                    getMainhandAttributes(mainhand_), ',',
                    getOffhandAttributes(offhand_),   ',',
                    getChampionsAttribute(id_),     
                    ',{"trait_type": "level", "value":', toString(level_),
                    '},{"display_type": "boost_number","trait_type": "zug bonus", "value":', 
                    toString(zugModifier_),'}]'));
       }

        return string(abi.encodePacked(
           '"attributes": [',
            getBodyAttributes(body_),         ',',
            getHelmAttributes(helm_),         ',',
            getMainhandAttributes(mainhand_), ',',
            getOffhandAttributes(offhand_), 
            ',{"trait_type": "level", "value":', toString(level_),
            '},{"display_type": "boost_number","trait_type": "zug bonus", "value":', 
            toString(zugModifier_),'}]'));

    }

    function getBodyAttributes(uint8 body_) internal view returns(string memory) {
        NameHandlerLike handler = NameHandlerLike(body_ > 52 ? equipmentHandler : impl);
        return string(abi.encodePacked('{"trait_type":"Body","value":"',handler.getBodyName(body_),'"}'));
    }

    function getHelmAttributes(uint8 helm_) internal view returns(string memory) {
        NameHandlerLike handler = NameHandlerLike(helm_ > 52 ? equipmentHandler : impl);
        return string(abi.encodePacked('{"trait_type":"Helm","value":"',handler.getHelmName(helm_),'"},{"display_type":"number","trait_type":"HelmTier","value":',toString(getTier(helm_)),'}'));
    }

    function getMainhandAttributes(uint8 mainhand_) internal view returns(string memory) {
        NameHandlerLike handler = NameHandlerLike(mainhand_ > 52 ? equipmentHandler : impl);
        return string(abi.encodePacked('{"trait_type":"Mainhand","value":"',handler.getMainhandName(mainhand_),'"},{"display_type":"number","trait_type":"MainhandTier","value":',toString(getTier(mainhand_)),'}'));
    }

    function getOffhandAttributes(uint8 offhand_) internal view returns(string memory) {
        NameHandlerLike handler = NameHandlerLike(offhand_ > 52 ? equipmentHandler : impl);
        return string(abi.encodePacked('{"trait_type":"Offhand","value":"',handler.getOffhandName(offhand_),'"},{"display_type":"number","trait_type":"OffhandTier","value":',toString(getTier(offhand_)),'}'));
    }

    function getChampionsAttribute(uint256 id) internal view returns(string memory) {
        uint256 daysAsChampion = NameHandlerLike(nameHandler).timeAsChampion(id) / 1 days;
        return string(abi.encodePacked('{"display_type":"number","trait_type":"DaysAsTopChampion","value":"',toString(daysAsChampion),'"}'));
    }

    function _getName(uint256 orcId) internal view returns (string memory) {
        if (nameHandler == address(0)) return string(abi.encodePacked("Orc #", toString(orcId)));
        return NameHandlerLike(nameHandler).getName(orcId);
    }

    function getTier(uint16 id) internal pure returns (uint16) {
        if (id > 40) return 10;
        if (id == 0) return 0;
        return ((id - 1) / 4 );
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

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

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides a function for encoding some bytes in base64
/// @notice NOT BUILT BY ETHERORCS TEAM. Thanks Bretch Devos!
library BBase64 {
    string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';
        
        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)
            
            // prepare the lookup table
            let tablePtr := add(table, 1)
            
            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))
            
            // result ptr, jump over length
            let resultPtr := add(result, 32)
            
            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
               dataPtr := add(dataPtr, 3)
               
               // read 3 bytes
               let input := mload(dataPtr)
               
               // write 4 characters
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
               resultPtr := add(resultPtr, 1)
            }
            
            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }
        
        return result;
    }
}

contract EquipmentHandler {

    function getBodyName(uint8 id) external pure returns (string memory){
        if (id == 53) return "Sun Wukong";
        return "";
    }
    function getHelmName(uint8 id) external pure returns (string memory){
        if (id == 53) return "Sun Wukong";
        return "";
    }
    function getMainhandName(uint8 id) external pure returns (string memory){
        if (id == 53) return "Sun Wukong";
        return "";
    }
    function getOffhandName(uint8 id) external pure returns (string memory){
        if (id == 53) return "Sun Wukong";
        return "";
    }
}

contract NameHandler {

    function getName(uint256 orcId) external view returns(string memory) {
        return "Fuck Yeeeah";
    }

    function timeAsChampion(uint256 id) external view returns(uint256) {
        return 3 days;
    }

}