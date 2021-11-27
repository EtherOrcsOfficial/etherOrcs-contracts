// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import {RLPReader} from "../../extLib/FxPortal/lib/RLPReader.sol";
import {MerklePatriciaProof} from "../../extLib/FxPortal/lib/MerklePatriciaProof.sol";
import {Merkle} from "../../extLib/FxPortal/lib/Merkle.sol";
import "../../extLib/FxPortal/lib/ExitPayloadReader.sol";

interface IFxStateSender {
    function sendMessageToChild(address _receiver, bytes calldata _data) external;
}

interface ICheckpointManager {
    function headerBlocks(uint256 headerBlock) external view returns (bytes32 root,uint256 start,uint256 end,uint256 createdAt,address proposer);
}

/// @dev This is portal that just execute the bridge from L1 <-> L2
contract MainlandPortal {
    using RLPReader for RLPReader.RLPItem;
    using Merkle for bytes32;
    using ExitPayloadReader for bytes;
    using ExitPayloadReader for ExitPayloadReader.ExitPayload;
    using ExitPayloadReader for ExitPayloadReader.Log;
    using ExitPayloadReader for ExitPayloadReader.LogTopics;
    using ExitPayloadReader for ExitPayloadReader.Receipt;

    /*///////////////////////////////////////////////////////////////
                    PORTAL STATE
    //////////////////////////////////////////////////////////////*/

    address        implementation_;
    address public admin;

    // keccak256(MessageSent(bytes))
    bytes32 public constant SEND_MESSAGE_EVENT_SIG = 0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036;

    IFxStateSender     public fxRoot;
    ICheckpointManager public checkpointManager;

    address public polylandPortal;

    mapping(bytes32 => bool) public processedExits;
    mapping(address => bool) public auth;

    event CallMade(address target, bool success, bytes data);

    /*///////////////////////////////////////////////////////////////
                    ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function initialize(address fxRoot_, address checkpointManager_, address polylandPortal_) external {
        // Just for testnets, on mainnet the admin is already set
        admin = msg.sender;

        fxRoot            = IFxStateSender(fxRoot_);
        checkpointManager = ICheckpointManager(checkpointManager_);
        
        polylandPortal = polylandPortal_;
    }

    function setAuth(address[] calldata adds_, bool status) external {
        require(msg.sender == admin, "not admin");
        for (uint256 index = 0; index < adds_.length; index++) {
            auth[adds_[index]] = status;
        }
    }

    /*///////////////////////////////////////////////////////////////
                    PORTAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/


    function sendMessage(bytes calldata message_) external {
        require(auth[msg.sender], "not authorized to use portal");

        fxRoot.sendMessageToChild(polylandPortal, message_);
    }

     function replayCall(address target, bytes memory data, bool reqSuccess) external {
        require(msg.sender == admin, "not allowed");
        (bool succ, ) = target.call(data);
        if (reqSuccess) require(succ, "call failed");
    }

    /// @dev executed when we receive a message from Polygon
    function _processMessageFromChild(bytes memory data) internal {
        (address target, bytes[] memory calls ) = abi.decode(data, (address, bytes[]));
        for (uint256 i = 0; i < calls.length; i++) {
            (bool succ, ) = target.call(calls[i]);
            emit CallMade(target, succ, calls[i]);
        }
    }


    /*///////////////////////////////////////////////////////////////
                    FXPORTAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    // taken from https://github.com/fx-portal/contracts

    function _validateAndExtractMessage(bytes memory inputData) internal returns (bytes memory) {
        ExitPayloadReader.ExitPayload memory payload = inputData.toExitPayload();

        bytes memory branchMaskBytes = payload.getBranchMaskAsBytes();
        uint256 blockNumber = payload.getBlockNumber();
        // checking if exit has already been processed
        // unique exit is identified using hash of (blockNumber, branchMask, receiptLogIndex)
        bytes32 exitHash = keccak256(
            abi.encodePacked(
                blockNumber,
                // first 2 nibbles are dropped while generating nibble array
                // this allows branch masks that are valid but bypass exitHash check (changing first 2 nibbles only)
                // so converting to nibble array and then hashing it
                MerklePatriciaProof._getNibbleArray(branchMaskBytes),
                payload.getReceiptLogIndex()
            )
        );
        require(
            processedExits[exitHash] == false,
            "MainlandPortal: EXIT_ALREADY_PROCESSED"
        );
        processedExits[exitHash] = true;

        ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
        ExitPayloadReader.Log memory log = receipt.getLog();

        // check child tunnel
        require(polylandPortal == log.getEmitter(), "MainlandPortal: INVALID_FX_CHILD_TUNNEL");

        bytes32 receiptRoot = payload.getReceiptRoot();
        // verify receipt inclusion
        require(
            MerklePatriciaProof.verify(
                receipt.toBytes(), 
                branchMaskBytes, 
                payload.getReceiptProof(), 
                receiptRoot
            ),
            "MainlandPortal: INVALID_RECEIPT_PROOF"
        );

        // verify checkpoint inclusion
        _checkBlockMembershipInCheckpoint(
            blockNumber,
            payload.getBlockTime(),
            payload.getTxRoot(),
            receiptRoot,
            payload.getHeaderNumber(),
            payload.getBlockProof()
        );

        ExitPayloadReader.LogTopics memory topics = log.getTopics();

        require(
            bytes32(topics.getField(0).toUint()) == SEND_MESSAGE_EVENT_SIG, // topic0 is event sig
            "MainlandPortal: INVALID_SIGNATURE"
        );

        // received message data
        (bytes memory message) = abi.decode(log.getData(), (bytes)); // event decodes params again, so decoding bytes to get message
        return message;
    }

    function _checkBlockMembershipInCheckpoint(
        uint256 blockNumber,
        uint256 blockTime,
        bytes32 txRoot,
        bytes32 receiptRoot,
        uint256 headerNumber,
        bytes memory blockProof
    ) private view returns (uint256) {
        (
            bytes32 headerRoot,
            uint256 startBlock,
            ,
            uint256 createdAt,

        ) = checkpointManager.headerBlocks(headerNumber);

        require(
            keccak256(
                abi.encodePacked(blockNumber, blockTime, txRoot, receiptRoot)
            )
                .checkMembership(
                blockNumber-startBlock,
                headerRoot,
                blockProof
            ),
            "MainlandPortal: INVALID_HEADER"
        );
        return createdAt;
    }

    /**
     * @notice receive message from  L2 to L1, validated by proof
     * @dev This function verifies if the transaction actually happened on child chain
     *
     * @param inputData RLP encoded data of the reference tx containing following list of fields
     *  0 - headerNumber - Checkpoint header block number containing the reference tx
     *  1 - blockProof - Proof that the block header (in the child chain) is a leaf in the submitted merkle root
     *  2 - blockNumber - Block number containing the reference tx on child chain
     *  3 - blockTime - Reference tx block time
     *  4 - txRoot - Transactions root of block
     *  5 - receiptRoot - Receipts root of block
     *  6 - receipt - Receipt of the reference transaction
     *  7 - receiptProof - Merkle proof of the reference receipt
     *  8 - branchMask - 32 bits denoting the path of receipt in merkle tree
     *  9 - receiptLogIndex - Log Index to read from the receipt
     */
    function receiveMessage(bytes calldata inputData) public virtual {
        bytes memory message = _validateAndExtractMessage(inputData);
        _processMessageFromChild(message);
    }
    
}