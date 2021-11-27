// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");  

async function main() {
    await hre.run("compile");

    let orcAddress    = "0x100DB46daf1Ec32Fb6ba8cEeF7D5bF5BD14aBF05"
    let castleAddress = "0xB99E3b47cD69d72b2D1bE8E790476a69c22D4F99"
    let raidsAddress  = "0xf4df86af5DfD77cc12bF648a4444041984E8266E"
    let portalAddress = "0xE348085162D8fe80e6af99421AB7427166fad326"
    let zugAddress    = "0x516285C190c7878cabB4F85a948e62ff3399883D"
    let shrAddress    = "0x58D286E8d5587b7DC806Df5b0a9759248549484f"
    let hallAddress   = "0x80577006D61abf19D6E2B295D00ae64A9109133c"

    // Config everything
    console.log("Starting config");

    let portal = await hre.ethers.getContractAt("MainlandPortal", portalAddress)
    let c = await portal.setAuth([castleAddress], true);

    let orc = await hre.ethers.getContractAt("Rinkorc", orcAddress)
    await orc.setZug(zugAddress);
    await orc.setCastle(castleAddress)
    let t = await orc.setRaids(raidsAddress)
    console.log(t)
    await orc.setAuth(castleAddress, true)
    console.log("done orc")

    let hall = await hre.ethers.getContractAt("HallOfChampions", hallAddress)
    await hall.setAddresses(orcAddress, zugAddress);
    console.log("don hall")

    let zug = await hre.ethers.getContractAt("ERC20", zugAddress)
    await zug.setMinter(castleAddress, true)
    await zug.setMinter(orcAddress, true)
    await zug.setMinter(hallAddress, true)
    await zug.setMinter(raidsAddress, true)
    console.log("done zug")

    raids = await hre.ethers.getContractAt("Raids", raidsAddress)
    await raids.initialize(orcAddress, zugAddress, shrAddress, hallAddress)
    console.log("done raids")

    let shr = await hre.ethers.getContractAt("BoneShards", zugAddress)
    await shr.setMinter(castleAddress, true);
    await shr.setMinter(raidsAddress, true);
    console.log("done bonesdhards")

    let proxyCastle = await hre.ethers.getContractAt("Castle", castleAddress);
    await proxyCastle.initialize(portalAddress, orcAddress, zugAddress, shrAddress)
    console.log("done castle")
    for (let i = 0; i < 5051; i += 505) {
      await orc.initMint(orcAddress, i, i + 505)
    }
    console.log("inited")

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
