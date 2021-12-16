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
    "Castle": "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9",
}

async function main() {
  await hre.run("compile");

  // await updateProxy("MumbaiAllies",proxies["MumbaiAllies"]);
  // await updateProxy("RaidsPoly",proxies["RaidsPoly"]);
  await updateProxy("Castle",proxies["Castle"]);
  // await updateProxy("EtherOrcsItems", proxies["EtherOrcsItems"]);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
