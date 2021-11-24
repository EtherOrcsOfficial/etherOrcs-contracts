// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");  

async function main() {
  console.log(hre.config.solidity.compilers[0])
    await hre.run("compile");

    const ProxyFac = await hre.ethers.getContractFactory("Proxy");

    // Orcs Deployment
    console.log("Deploying Orcs")
    const OrcFactory = await hre.ethers.getContractFactory("Rinkorc");
    let orcImpl = await OrcFactory.deploy()
    await orcImpl.deployed();
    console.log("orc implementation", orcImpl.address)

    let orc = await ProxyFac.deploy(orcImpl.address);
    await orc.deployed()
    console.log("orc: ", orc.address)

    // Deploying castle
    console.log("Deploying Castle")
    const CastleFactory = await hre.ethers.getContractFactory("Castle");
    let castleImpl = await CastleFactory.deploy();
    console.log("castle impl", castleImpl.address)

    
    let castle = await ProxyFac.deploy(castleImpl.address);
    await castle.deployed();
    console.log("castle address", castle.address);

    //Deploying Raids
    console.log("Deploying Raids")
    const RaidsFact = await hre.ethers.getContractFactory("Raids")
    let raidsImpl = await RaidsFact.deploy()
    await raidsImpl.deployed()
    console.log("raids impl", raidsImpl.address)
    let raids= await ProxyFac.deploy(raidsImpl.address)
    console.log("raids address", raids.address)


    // Getting existing Portal
    const PortalFactory = await hre.ethers.getContractFactory("PolylandPortal");
    let  portalImpl = await PortalFactory.deploy()
    await portalImpl.deployed();
    console.log("portal impl: ", portalImpl.address)

    let portal = await ProxyFac.deploy(portalImpl.address)
    await portal.deployed()
    console.log("portal", portal.address)

    // Getting Zug
    const ZugFac = await hre.ethers.getContractFactory("ERC20");
    let zug = await ZugFac.deploy()
    await zug.deployed();
    console.log("zug:", zug.address)

    // Getting BoneShards
    const BoneFact = await hre.ethers.getContractFactory("BoneShards");
    let shr = await BoneFact.deploy()
    await shr.deployed()
    console.log("bone", shr.address)

    // getting Hall of Champions
    const HallFact = await hre.ethers.getContractFactory("HallOfChampions");
    let hallImpl = await HallFact.deploy()
    await hallImpl.deployed();
    console.log("hallImpl: ", hallImpl.address)

    let hall = await ProxyFac.deploy(hallImpl.address)
    await hall.deployed()
    console.log("hall: ", hall.address)

    // Config everything
    console.log("Starting config");

    portal = await hre.ethers.getContractAt("PolylandPortal", portal.address)
    await portal.setAuth([castle.address], true);

    orc = await hre.ethers.getContractAt("Rinkorc", orc.address)
    await orc.setZug(zug.address);
    await orc.setCastle(castle.address)
    await orc.setRaids(raids.address)
    await orc.setAuth(castle.address, true)
    console.log("done orc")

    hall = await hre.ethers.getContractAt("HallOfChampions", hall.address)
    await hall.setAddresses(orc.address, zug.address);
    console.log("don hall")

    await zug.setMinter(castle.address, true)
    await zug.setMinter(orc.address, true)
    await zug.setMinter(hall.address, true)
    await zug.setMinter(raids.address, true)
    console.log("done zug")

    raids = await hre.ethers.getContractAt("Raids", raids.address)
    await raids.initialize(orc.address, zug.address, shr.address, hall.address)
    console.log("done raids")

    await shr.setMinter(castle.address, true);
    await shr.setMinter(raids.address, true);
    console.log("done bonesdhards")

    let proxyCastle = await hre.ethers.getContractAt("Castle", castle.address);
    await proxyCastle.initialize(portal.address, orc.address, zug.address, shr.address)
    console.log("done castle")
    for (let i = 0; i < 5051; i += 505) {
      await orc.initMint(orc.address, i, i + 505)
    }
    console.log("inited")

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
