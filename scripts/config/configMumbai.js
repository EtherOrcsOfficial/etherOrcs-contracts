// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");  

async function main() {
    await hre.run("compile");

    let orcAddress    = "0x84698a8EE5B74eB29385134886b3a182660113e4"
    let castleAddress = "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9"
    let raidsAddress  = "0xf4df86af5DfD77cc12bF648a4444041984E8266E"
    let portalAddress = "0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4"
    let zugAddress    = "0xeb45921FEDaDF41dF0BfCF5c33453aCedDA32441"
    let shrAddress    = "0x62Add2b8Ff6E7a35720A001B40C22588D584FD13"
    let hallAddress   = "0x5983Efff5B7130903bEFc9b0d46f9ebCf009769B"

    // Config everything
    console.log("Starting config");

    let portal = await hre.ethers.getContractAt("PolylandPortal", portalAddress)
    // let c = await portal.setAuth([castleAddress], true);

    let orc = await hre.ethers.getContractAt("EtherOrcsPoly", orcAddress)
    await orc.setZug(zugAddress);
    await orc.setCastle(castleAddress)
    let t = await orc.setRaids(raidsAddress)
    console.log(t)
    await orc.setAuth(castleAddress, true)
    console.log("done orc")

    let hall = await hre.ethers.getContractAt("HallOfChampionsPolygon", hallAddress)
    // await hall.setAddresses(orcAddress, zugAddress);
    console.log("don hall")

    let zug = await hre.ethers.getContractAt("PolyZug", zugAddress)
    await zug.setMinter(castleAddress, true)
    await zug.setMinter(orcAddress, true)
    await zug.setMinter(hallAddress, true)
    await zug.setMinter(raidsAddress, true)
    console.log("done zug")

    raids = await hre.ethers.getContractAt("PolyRaids", raidsAddress)
    await raids.initialize(orcAddress, zugAddress, shrAddress, hallAddress)
    console.log("done raids")

    let shr = await hre.ethers.getContractAt("PolyBoneShards", shrAddress)
    await shr.setMinter(castleAddress, true);
    await shr.setMinter(raidsAddress, true);
    console.log("done bonesdhards")

    let proxyCastle = await hre.ethers.getContractAt("Castle", castleAddress);
    await proxyCastle.initialize(portalAddress, orcAddress, zugAddress, shrAddress)
    console.log("done castle")
    // for (let i = 0; i < 5051; i += 505) {
    //   await orc.initMint(orcAddress, i, i + 505)
    // }
    console.log("inited")

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
