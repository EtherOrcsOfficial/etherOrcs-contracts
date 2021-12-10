// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat"); 

  const orcAddress    = "0x100DB46daf1Ec32Fb6ba8cEeF7D5bF5BD14aBF05"
  const castleAddress = "0xB99E3b47cD69d72b2D1bE8E790476a69c22D4F99"
  const raidsAddress  = "0xf4df86af5DfD77cc12bF648a4444041984E8266E"
  const alliesAddress = "0x4971Ded74A45FB7bB85Be6c3b0ED7A3B08AF86C1"
  const portalAddress = "0xE348085162D8fe80e6af99421AB7427166fad326"
  const zugAddress    = "0x516285C190c7878cabB4F85a948e62ff3399883D"
  const shrAddress    = "0x58D286E8d5587b7DC806Df5b0a9759248549484f"
  const hallAddress   = "0x80577006D61abf19D6E2B295D00ae64A9109133c"


async function updateCastle() {
    console.log("Deploying new Castle");
    const castleFactory = await hre.ethers.getContractFactory("Castle");
    let castleImpl = await castleFactory.deploy();
    console.log("castle impl", castleImpl.address);

    console.log("Updating Castle");
    let cast = await hre.ethers.getContractAt("Proxy", castleAddress);
    await cast.setImplementation(castleImpl.address);
}

async function updateRaids() {
    console.log("Deploying new Raids");
    const raidsFactory = await hre.ethers.getContractFactory("PolyRaids");
    let raidsImpl = await raidsFactory.deploy();
    console.log("raidsImpl", raidsImpl.address);

    console.log("Updating Raids");
    let cast = await hre.ethers.getContractAt("Proxy", raidsAddress);
    await cast.setImplementation(raidsImpl.address);
}

async function deployAllies() {
    // Alliess Deployment
    console.log("Deploying Alliess")
    const AlliesFactory = await hre.ethers.getContractFactory("MumbaiAllies");
    let alliesImpl = await AlliesFactory.deploy()
    await alliesImpl.deployed();
    console.log("Allies_impl:", alliesImpl.address)

    const ProxyFac = await hre.ethers.getContractFactory("Proxy");

    let allies = await ProxyFac.deploy(alliesImpl.address);
    await allies.deployed()
    console.log("Allies: ", allies.address)

    let a = await hre.ethers.getContractAt("MumbaiAllies", allies.address)
    return a;
}

async function main() {
    await hre.run("compile");

    // await updateCastle();
    
    // await updateRaids();


    // const ProxyFac = await hre.ethers.getContractFactory("Proxy");

    // let allies = await deployAllies();

    // Config everything
    // console.log("Starting config");

    let allies = await hre.ethers.getContractAt("MumbaiAllies", alliesAddress)
    // await allies.setCastle(castleAddress)
    // await allies.setRaids(raidsAddress)
    // await allies.setAuth(castleAddress, true)
    // console.log("done allies")

    // let shr = await hre.ethers.getContractAt("PolyBoneShards", "0x58D286E8d5587b7DC806Df5b0a9759248549484f")

    // await shr.setMinter(allies.address, true);
    // console.log("done bonesdhards")

    // let proxyCastle = await hre.ethers.getContractAt("Castle", castleAddress);
    // await proxyCastle.setAllies(alliesAddress)
    // console.log("done castle")

    for (let i = 5051; i < (8051 - 300); i += 300) {
      console.log("iteration:", i)
      await allies.initMint(castleAddress, i, i + 300)
    }
    console.log("inited")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
