# EtherOrcs
The smart contracts for the on-chain rpg game EtherOrcs!

## About
EtherOrcs is mainly divide between Ethereum Mainnet and Polygon POS chain. The core of the Orcs game was built for mainnet only, but increasing gas prices made us provide a cheaper solution for gameplay.

In theory, contracts that are in the shared folder are deployed on both chains, and chain-specific contracts are in their own folder.

We use proxy patterns on most contracts because we want to provide the best user experience, which is hard to foresee. We do expected to slowly ossify the upgrades and eventually burn the admin keys so the game remains immutable.

## About the Repo
For development, we use dapptools, which offers some interesting capabilities in a concise way. 

For deployments. we use the deployer folder, which contains hardhat scripts.



### Testnet deployment

Goerli:
```
EtherOrcs:  0x100DB46daf1Ec32Fb6ba8cEeF7D5bF5BD14aBF05
Castle:     0xB99E3b47cD69d72b2D1bE8E790476a69c22D4F99
Raids:      0xf4df86af5DfD77cc12bF648a4444041984E8266E
Portal:     0xE348085162D8fe80e6af99421AB7427166fad326
Zug:        0x516285C190c7878cabB4F85a948e62ff3399883D
BoneShards: 0x58D286E8d5587b7DC806Df5b0a9759248549484f
Hall:       0x80577006D61abf19D6E2B295D00ae64A9109133c

EtherOrcs_impl: 0x0C8A7314BE753De7D01Dd5178aB8D930e29CEd56
Castle_impl:    0x76a848EE0bb4173C7943F7a8E2555879cf5BbCDA
Raids_impl:     0x39f943Ebf546b73d04A31622F40323158bf67b7F
Portal_impl:    0x9715f8B0b7a8b8F93493784167a96de812899F77
Hall_Impl:      0x60dfC72Bd565f65EEe85f8b56302A3b03CF704DB
```


Mumbai:
```
EtherOrcs:  0x100DB46daf1Ec32Fb6ba8cEeF7D5bF5BD14aBF05
Castle:     0xB99E3b47cD69d72b2D1bE8E790476a69c22D4F99
Raids:      0xf4df86af5DfD77cc12bF648a4444041984E8266E
Portal:     0xE348085162D8fe80e6af99421AB7427166fad326
Zug:        0x516285C190c7878cabB4F85a948e62ff3399883D
BoneShards: 0x58D286E8d5587b7DC806Df5b0a9759248549484f
Hall:       0x80577006D61abf19D6E2B295D00ae64A9109133c

EtherOrcs_impl: 0x0C8A7314BE753De7D01Dd5178aB8D930e29CEd56
Castle_impl:    0x76a848EE0bb4173C7943F7a8E2555879cf5BbCDA
Raids_impl:     0x39f943Ebf546b73d04A31622F40323158bf67b7F
Portal_impl:    0x9715f8B0b7a8b8F93493784167a96de812899F77
Hall_Impl:      0x60dfC72Bd565f65EEe85f8b56302A3b03CF704DB
```