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
    "EtherOrcsItems": "0xd769705e0F6265F12c13CE85aEB7a1218D655cfD",
    "EtherOrcsAlliesPoly": "0xbFF91E8592e5Ba6A2a3e035097163A22e8f9113A",
    "EtherOrcsPoly": "0x84698a8EE5B74eB29385134886b3a182660113e4",
    "Castle": "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9",
    "RaidsPoly": "0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4",
    "PotionVendor": "0xBb477E51A4E28280cB1839cb2F8AB551b24834Ae",
    "InventoryManagerAllies": "0xA873dF562Eb39A3c560038Fc2c3D5b1C09C03b82",
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
