# EtherOrcs
The smart contracts for the on-chain rpg game EtherOrcs!

## About
EtherOrcs is mainly divide between Ethereum Mainnet and Polygon POS chain. The core of the Orcs game was built for mainnet only, but increasing gas prices made us provide a cheaper solution for gameplay.

In theory, contracts that are in the shared folder are deployed on both chains, and chain-specific contracts are in their own folder.

We use proxy patterns on most contracts because we want to provide the best user experience, which is hard to foresee. We do expected to slowly ossify the upgrades and eventually burn the admin keys so the game remains immutable.

## About the Repo
For development, we use dapptools, which offers some interesting capabilities in a concise way. 

For deployments. we use the deployer folder, which contains hardhat scripts.

### Mainnet deployment

Polygon:
```
EtherOrcs:    0x84698a8EE5B74eB29385134886b3a182660113e4
Allies:       0xbFF91E8592e5Ba6A2a3e035097163A22e8f9113A
Castle:       0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9
Raids:        0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4
Portal:       0x752FF322640f9BF6FEa44854B42b92DcdfC1C876
Zug:          0xeb45921FEDaDF41dF0BfCF5c33453aCedDA32441
BoneShards:   0x62Add2b8Ff6E7a35720A001B40C22588D584FD13
Hall:         0x5983Efff5B7130903bEFc9b0d46f9ebCf009769B
PotionVendor: 0xBb477E51A4E28280cB1839cb2F8AB551b24834Ae
GamingOracle: 0x04A0B7E35828c985e78E2F1107e0B1C3FE39a837
Items(Potions): 0xd769705e0F6265F12c13CE85aEB7a1218D655cfD

Mangers:
InventoryManagerPoly:
InventoryManagerAllies: 0xA873dF562Eb39A3c560038Fc2c3D5b1C09C03b82
IncentoryManagerItems:  0xb5845385B08F23c0Dc679e982B6408F456de7826

Inventory:
Bodies1:    0xCF6c563D8817c49750E6300d30B1a2d4dC9F01f1
Bodies2:    0x929D887b14af4a0A35B847B36D7b88FF036014c2
FeatA:      0xa89aebD24286752FD82533916C54d99dFc56A6c7
FeatB:      0x2Abe8Ba8eBBE1AbeAbd25E59C557eA4c5a4bAF2C
Helms1:     0xD8883e5D719641f0F0342cCe052DCd883E6382bd
Helms2:     0x92Dcd422875508bE4A5c96E026e0fd87E91Dce22
Helms3:     0x7dbD960b115B911799631015b96B6fb97FfC6CD0
Mainhands1: 0xF960eE2C6d589D21a05007e0856c610B9B1cBa24
Mainhands2: 0x99457563Ca723592fF360fAa25e678f15F4b78E0
Mainhands3: 0x56620950144A31ab72C60Ef2274F1ebD8ddd6Ef4
Offhands1:  0x9f40bEe4d33d2939bFc3ddA77F6ddC254c480955
Offhands2:  0xD3EA234aBAbA7fdca40e320B7fa2e4E43bbD5C88
Offhands3:  0xda11cc98ebEC540414d0467016A1d3fF50d09b03

```

Ethereum Mainnet:
```
EtherOrcs:  0x3aBEDBA3052845CE3f57818032BFA747CDED3fca
Allies:     0x62674b8aCe7D939bB07bea6d32c55b74650e0eaA
Castle:     0x2F3f840d17Eb61020680c1f4B00510c3CaA7dF63
Raids:      0x47DC8e20C15f6deAA5cBFeAe6cf9946aCC89af59
Portal:     0xcf586c68661c4a0358c79D33961C8FFeB59Ee162
Zug:        0xfEE5F54e1070e7eD31Be341e0A5b1E847f6a84Ab
BoneShards: 0x6c716bDB4289283e0ad1926c47B54412Bd2C257B
Hall:       0x32da11ABda542c415ea59ee04c5Bf578c1F0cd3d

Manager
InvtoryManagerAllies: 0xf286aa8c83609328811319af2f223bcc5b6db028

Inventory (Allies):
Bodies1:    0x3719a5E8138F84F78702bbFCe381cdf9424E7129
Bodies2:    0x97053f88f3Bda9C2C3CCeA2d4883c67Aec4a858c
FeatA:      0xcD19feE45acAe960b8fa235ae1432BD0fc80b0d3
FeatB:      0xD49a92d2E354D7f2fF86404D1d047936Dcb282c2
Helms1:     0x81169cCa13390504a8c6a86b1D21bEE58A87a5F5
Helms2:     0xfe170B5ED24d072FB0cf29335554cb1563476919
Helms3:     0x9baaC2082A2BBbECb82eD0e7C31f3748B64a84c8
Mainhands1: 0x32F1ce03d4AEeBa35D5F4D529420cb89f879222a
Mainhands2: 0x25FcE46005D6197276702ca2611306b63C3f043C
Mainhands3: 0x1beE6BA5ef5912eB832f0e343BE2634c23f2d4dB
Offhands1:  0x1F791d41CDFcBf9d16D376AF6879512CC9c4faa7
Offhands2:  0x03d7b4a48d5731cF547Bf6A545Fe9D87F11e5c1b
Offhands3:  0xa4884880BaEbdde12D30E24dB0F909c3441686c9

```