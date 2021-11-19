# Orcish Portal Quick guide

The Orcish Portal are a set of contracts that define how orc tokens, like Zug and BoneShards, orcs and allies travel between Mainnet Ethereum and Polygon.

### Start travel
On both sides of the portal we define a function to initiate a travel (from Mainnet -> Polygon or Polyogn -> Mainnet).

```js
function travel(uint256[] calldata orcsIds, uint256[] calldata alliesIds, uint256 zugAmount, uint256 shrAmount) external
```

A given user will select which of it's own assets it'll send to the other side and the GUI will build a transaction with this data. The contracts will handle the rest.

### Receiving travel

When the transaction is originated on mainnet, the user interaction ends there. It's only a matter of time until polygon updates it's states and the user receives it's elements directly on it's wallet.

However, when the transaction is originated on Polygon with destination mainnet, there's anther transaction needed.

1. First step is to save the hash of the initial transaction (i.e the call to `travel`)
2. After that, we need to calculate the proof of execution. This process is described here: https://docs.polygon.technology/docs/develop/l1-l2-communication/state-transfer#state-transfer-from-polygon-to-ethereum

The gist is to use maticjs lib to generate this blob of data, passing the tx hash saved on step 1.

3. After some time (Polygon says 30min to 3h) the transaction will be ready to be redeemed. For this, the user needs to take the outup of 2, and then input into the following function:

```js
function receiveMessage(bytes calldata inputData) public; // defined in MainlandPortal.sol
```

This is the transaction that will execute the unlocking of orcs and tokens to the user wallet.