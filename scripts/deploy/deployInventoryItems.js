// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");


async function deployProxied(contractName) {
  console.log("Deploying", contractName)
  const InventoryManagerFactory = await hre.ethers.getContractFactory(contractName);
  let invMan = await InventoryManagerFactory.deploy();
  console.log(invMan.address)

  console.log("Deploying Proxy")
  const ProxyFac = await hre.ethers.getContractFactory("Proxy");
  let pp = await ProxyFac.deploy(invMan.address);
  console.log(pp.address)

  let a = await hre.ethers.getContractAt(contractName, pp.address);
  return a;
}

async function deploy(contractName) {
  console.log("Deploying Inv Manager")
  const Fact = await hre.ethers.getContractFactory(contractName);
  let impl = await Fact.deploy();
  console.log(impl.address)
  return impl;
}


async function main() {

  await hre.run("compile");

  // Update Items
  console.log("Deplpoying Inv Man")
  let invMan = await deployProxied("InventoryManagerItems")

  console.log("Deploying Potion")
  let potion = await deploy("Potion");
  await invMan.setSvg(1, potion.address);

  console.log("Deploying Dummy")
  let dummy = await deploy("Dummy");
  await invMan.setSvg(2, dummy.address);

  console.log("Deploying LavaRock")
  let lavaRock = await deploy("LavaRock");
   await invMan.setSvg(99, lavaRock.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
