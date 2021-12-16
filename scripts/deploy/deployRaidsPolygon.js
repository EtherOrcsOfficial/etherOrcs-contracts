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
	const ORACLE = "0x04A0B7E35828c985e78E2F1107e0B1C3FE39a837";
	const RAIDS = "0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4";
    const ALLIES = "0xbFF91E8592e5Ba6A2a3e035097163A22e8f9113A";
	const VENDOR = "0xBb477E51A4E28280cB1839cb2F8AB551b24834Ae";
	const ITEMS = "0xd769705e0F6265F12c13CE85aEB7a1218D655cfD";

    // let raids = await updateProxy("RaidsPoly", RAIDS);

    let raids = await hre.ethers.getContractAt("RaidsPoly", RAIDS);

    await raids.init(ALLIES, VENDOR,ITEMS, ORACLE);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
