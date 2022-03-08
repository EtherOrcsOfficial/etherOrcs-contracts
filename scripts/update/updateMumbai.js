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


let proxies  = {
    "RaidsPoly": "0x29b1f8C7146d153350061a98446a1D8D1b83b4E0",
    "MumbaiAllies": "0xc702DFd49Dfc02a71799DBC700FA688C1E14618a",
}

async function main() {
  await hre.run("compile");

  // await updateProxy("MumbaiAllies",proxies["MumbaiAllies"]);
  
  let allies = await hre.ethers.getContractAt("MumbaiAllies", proxies["MumbaiAllies"])

  for (let i = 8201; i < 17051; i += 205) {
    console.log("Transfering", i);
		await allies.forceTransfer("0x244Ab8Fe8b8fA0B716DF6b89aC80f8d02fA85cF0", "0xA3C19786F60F527c8F60B11032eFEc5581630Fd2",  i, i + 205);
	}

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
