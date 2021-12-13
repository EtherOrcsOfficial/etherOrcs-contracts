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
Allies:     0x8F05135c154F83907cE5b794373C9D76587867C1
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
Allies:     0x4971Ded74A45FB7bB85Be6c3b0ED7A3B08AF86C1
Castle:     0xB99E3b47cD69d72b2D1bE8E790476a69c22D4F99
Raids:      0xf4df86af5DfD77cc12bF648a4444041984E8266E
Portal:     0xE348085162D8fe80e6af99421AB7427166fad326
Zug:        0x516285C190c7878cabB4F85a948e62ff3399883D
BoneShards: 0x58D286E8d5587b7DC806Df5b0a9759248549484f
Hall:       0x80577006D61abf19D6E2B295D00ae64A9109133c
Potions:    0xb7af5dA532bDd65921e3c30572eD2dE73964B9B2

EtherOrcs_impl: 0x0C8A7314BE753De7D01Dd5178aB8D930e29CEd56
Castle_impl:    0x76a848EE0bb4173C7943F7a8E2555879cf5BbCDA
Raids_impl:     0x39f943Ebf546b73d04A31622F40323158bf67b7F
Portal_impl:    0x9715f8B0b7a8b8F93493784167a96de812899F77
Hall_Impl:      0x60dfC72Bd565f65EEe85f8b56302A3b03CF704DB
```


Second Mumbai Deployment
Deploying Orcs
Orc_impl: 0xfD889D1DC37bA4b7E0444bCB5E7140374E0cA4EA
Orc:  0x9Ee5F6C8B02908a29f111cA9B7B93e61d2374ab1
Deploying Allies
Ally_impl: 0xbb86bC9e153201E753547AfbF54800AD15760eA0
Ally:  0x31d5CdDEfFb400634362411a770443dD13000dF0
Deploying Castle
Castle_impl: 0x8F05135c154F83907cE5b794373C9D76587867C1
Castle: 0x5a035d0c1E023dECa259E2450cA476dD6d2b2d3e
Deploying Raids
Raids_impl: 0x23Eb1757A171DF00ae486D237e42d4b9F344Ad6B
Raids: 0x88720b5f026f0905d40664E185Ef3081Bd420d5B
Portal_impl:  0x7A59085Fc60e7a9B7B7a1f0968b9f04F88457071
Portal: 0xE5B8F12c9FC0DB0b56A8e8EF0f6025F1C6770401
items_impl:  0x40ce79bB2047Bb00daea712DbfE1751Ef31F941D
items: 0xD7E2cC5C5d2c20216dfCd0b915480Ef2a1171f53
Zug: 0xc6125F82cE43FebE06128369C3fA2A00B1654491
BoneShards 0xC1B3D6d1Bf068d33389b69B3897ffb697eD84Bc9
Hall_impl:  0x61579100391CC920F5Dc9a7B310bC33d48FE3169
Hall:  0xF5e0b0440ca25Bfe8d04323628d67EafBc94B7Cb
PotionVendor_impl:  0x26B416Af70317f2C19A0087B300EF96e8f41883E
PotionVendor:  0xf714249B531c75e3C915b1C14677FE82399Be05e
GamingOracle_impl:  0x73cAe1A1045DE1e882c89c6E2e59C4e94815003D
GamingOracle:  0x78A665c21203537aE336b6D42e623337A8844f17

Second Orcs Deploying
Orc_impl: 0x61579100391CC920F5Dc9a7B310bC33d48FE3169
Orc:  0xF5e0b0440ca25Bfe8d04323628d67EafBc94B7Cb
Deploying Allies
Ally_impl: 0x26B416Af70317f2C19A0087B300EF96e8f41883E
Ally:  0xf714249B531c75e3C915b1C14677FE82399Be05e
Deploying Castle
Castle_impl: 0x73cAe1A1045DE1e882c89c6E2e59C4e94815003D
Castle: 0x78A665c21203537aE336b6D42e623337A8844f17
Deploying Raids
Raids_impl: 0xA62E6F4E2E3e5a61c5F9ce169672120125C146E3
Raids: 0x854AD1282Bb21c373142Eb9092bF00e1f3cd60e5
Portal_impl:  0x1f040fda110E928B6318969e0f1a33A38f3B48B9
Portal: 0x4F027dDa8320e192eAfF7a81D85B644705532465
Zug: 0x5353AF7Ba65Adb80976cc2aA826bE2753DDB9d7D
BoneShards 0x8B2f425841F6829F7161E4EAb076C613DbEE9DB8
Hall_impl:  0xFFf0c48260C7643fA72de428F46915c0f4b874e4
Hall:  0xa22Cc75b202C5d4f8f0b00A78827DaE2AD72F3Cf

Deploying Inv Manager
0xFe3eB12D311d71E4eA6837b5BC0EE5fcdb7a34fF
Deploying Proxy
0x436c522E0db1382aF6C1bCC9a6d610704cFBAfF2
Deploying Bodies1
address 0x4229cD3E5Cb85dbF93bC09555Ee860fE74eDe195
Setting as Bodies
Deploying Bodies2
address 0xb62a737AF40e9A95cd9B62111e213a53EfA6C6ed
Setting as Bodies
Deploying FeatA
address 0x9c94e7F87f89E3aB1Cb1704aEC12440D249DB935
Setting as featA
Deploying FeatB
address 0x8a007982ba052A0fedE354858253FE22C5268892
Setting as featB
Deploying Helms1
address 0xBC047adeB9e736A8E3a2e871192C115e3d077C39
Setting as Helms
Deploying Helms2
address 0x275826d7412Ca3E2ECe1595597F4281bC642e900
Setting as Helms
Deploying Helms3
address 0xF0EA6866026410bc46c95aD62eC8B5D066c1f574
Setting as Helms
Deploying Mainhands1
address 0x601D0f862Fc6276121298Cb955AA2F457dD1b1fF
Setting as Mainhands
Deploying Mainhands2
address 0xBD65e50E51AD1ed251eA5dF4166426109Accf19c
Setting as Mainhands
Deploying Mainhands3
address 0xA3201830aA69463304Cf6099beC6a6a16b4ff84B
Setting as Mainhands
Deploying Offhands1
address 0x070A5ADF49507813c68CB6e78FD0C6dED35D62c7
Setting as Offhands
Deploying Offhands2
address 0xb0D00988c6d866924Be825E4159572d90e957d31
Setting as Offhands
Deploying Offhands3
address 0x9f7942734FCEa8253A3565234C88dBb0c053f631
Setting as Offhands


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