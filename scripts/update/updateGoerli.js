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
    "Rinkorc": "0xB0ac8b65B2DC645415bc92428939d3b008A2f928",
    "InventoryManagerRogues": "0x5BE7b5A55d8D3cC8e7F530B9b99E59b27113d4E8",
    "InventoryManagerAllies": "0xf51E6d2B9B18E6E8c9B76c34f78159fcec5051cA"
}

async function main() {
  await hre.run("compile");

  await updateProxy("InventoryManagerRogues",proxies["InventoryManagerRogues"]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
