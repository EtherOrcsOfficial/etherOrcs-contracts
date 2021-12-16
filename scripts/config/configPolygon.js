// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");  

async function updateProxy(contractName, address) {
    console.log("Deploying", contractName)
  const ImplFact = await hre.ethers.getContractFactory(contractName);
  let impl = await ImplFact.deploy();
  console.log(impl.address)

  console.log("Updating Impl")
  let a = await hre.ethers.getContractAt("Proxy", address);
  await a.setImplementation(impl.address);
}

async function main() {
    await hre.run("compile");

    const BONE_SHARDS = "0x62Add2b8Ff6E7a35720A001B40C22588D584FD13";
	const CASTLE = "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9";
	const RAIDS = "0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4";
	const INVMANAGER = "0xA873dF562Eb39A3c560038Fc2c3D5b1C09C03b82";
	const ZUG = "0xeb45921FEDaDF41dF0BfCF5c33453aCedDA32441";
    const ALLIES = "0xbFF91E8592e5Ba6A2a3e035097163A22e8f9113A";
    const POTION = "0xBb477E51A4E28280cB1839cb2F8AB551b24834Ae";
    const ORACLE = "0x04A0B7E35828c985e78E2F1107e0B1C3FE39a837";
    const ITEMS = "0xd769705e0F6265F12c13CE85aEB7a1218D655cfD";
    const ITEMSMAN = "0xd769705e0F6265F12c13CE85aEB7a1218D655cfD";

    // // Token configuration
	// const shr = await hre.ethers.getContractAt("BoneShardsPoly", BONE_SHARDS);
	// await shr.setMinter(ALLIES, true);
	// console.log("done bonesdhards");

	// const zug = await hre.ethers.getContractAt("ZugPoly", ZUG);
	// await zug.setMinter(ALLIES, true);
	// console.log("done zug")

    // await updateProxy("Castle", CASTLE);

    // const castle = await hre.ethers.getContractAt("Castle", CASTLE);
	// await castle.setAllies(ALLIES);
	// console.log("done castle");

    const allies = await hre.ethers.getContractAt("EtherOrcsAlliesPoly", ALLIES);
    for (let i = 7551; i < 8051; i += 500) {
		await allies.initMint(CASTLE, i, i + 500);
	}

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
