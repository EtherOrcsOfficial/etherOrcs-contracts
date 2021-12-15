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
EtherOrcs:  0x84698a8EE5B74eB29385134886b3a182660113e4
Castle:     0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9
Raids:      0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4
Portal:     0x752FF322640f9BF6FEa44854B42b92DcdfC1C876
Zug:        0xeb45921FEDaDF41dF0BfCF5c33453aCedDA32441
BoneShards: 0x62Add2b8Ff6E7a35720A001B40C22588D584FD13
Hall:       0x5983Efff5B7130903bEFc9b0d46f9ebCf009769B
```

Ethereum Mainnet:
```
EtherOrcs:  0x3aBEDBA3052845CE3f57818032BFA747CDED3fca
Castle:     0x2F3f840d17Eb61020680c1f4B00510c3CaA7dF63
Raids:      0x47DC8e20C15f6deAA5cBFeAe6cf9946aCC89af59
Portal:     0xcf586c68661c4a0358c79D33961C8FFeB59Ee162
Zug:        0xfEE5F54e1070e7eD31Be341e0A5b1E847f6a84Ab
BoneShards: 0x6c716bDB4289283e0ad1926c47B54412Bd2C257B
Hall:       0x32da11ABda542c415ea59ee04c5Bf578c1F0cd3d
```