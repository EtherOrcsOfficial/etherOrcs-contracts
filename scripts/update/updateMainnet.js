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
  await impl.deployed();

  console.log("Updating Impl")
  let a = await hre.ethers.getContractAt("Proxy", address);

  await a.setImplementation(impl.address);
}



let proxies  = {
    "Castle": "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9",
    "InventoryManagerShamans":"0xf286aa8c83609328811319af2f223bcc5b6db028",
    "InventoryManagerOgres": "0x81FA8559D8861F7b748db745C2C8dfdf6B3DFF68",
    "InventoryManagerAllies": "0xAA6647e4C507b2E30b4816963ABB2887585157eD",
    "MainlandPortal": "0xcf586c68661c4a0358c79D33961C8FFeB59Ee162",
    "EtherOrcsAllies": "0x62674b8aCe7D939bB07bea6d32c55b74650e0eaA"
}

async function main() {
  await hre.run("compile");
  await updateProxy("EtherOrcsAllies",proxies["EtherOrcsAllies"]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
