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
    "HordeUtilities": "0x8ba95eBB60bA80df0889CD323e1F972435a577a4"
}

async function main() {
  await hre.run("compile");
  await updateProxy("RaidsPoly",proxies["RaidsPoly"]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
