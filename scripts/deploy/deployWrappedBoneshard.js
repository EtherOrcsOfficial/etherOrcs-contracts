// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function deploy(contractName) {
  const Fact = await hre.ethers.getContractFactory(contractName);
  let impl = await Fact.deploy();
  console.log(`${contractName} deployed at: ${impl.address}`);
  return impl;
}

async function main() {
  console.log("main");
  await hre.run("compile");

  console.log("Deploying WrappedBoneshard");
  await deploy("WrappedBoneshard");
  console.log("Deploying InventoryManagerItems");
  await deploy("InventoryManagerItems");
  console.log("Deploying EtherOrcsItems");
  await deploy("EtherOrcsItems");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
