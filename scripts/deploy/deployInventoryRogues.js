// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");


async function deployInvManagerOgre() {
    console.log("Deploying Inv Manager")
  const InventoryManagerFactory = await hre.ethers.getContractFactory("InventoryManagerRogues");
  let invMan = await InventoryManagerFactory.deploy();
  console.log(invMan.address)

  console.log("Deploying Proxy")
  const ProxyFac = await hre.ethers.getContractFactory("Proxy");
  let pp = await ProxyFac.deploy(invMan.address);
  console.log(pp.address)

  let a = await hre.ethers.getContractAt("InventoryManagerRogues", pp.address);
  return a;
}

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

async function main() {

  await hre.run("compile");

  let allies = await deployProxied("TestAllies");

  let inv = await deployProxied("InventoryManagerRogues");
 
  let gen = await deployProxied("InventoryManagerAllies"); 
 

  await gen.setAddresses(inv.address,inv.address,inv.address,inv.address)
  await allies.initialize(gen.address, gen.address, gen.address)

  // let inv = await hre.ethers.getContractAt("InventoryManagerRogues", "0x5BE7b5A55d8D3cC8e7F530B9b99E59b27113d4E8");

  // Now deploy all of the art
    let svgs = [
                {name: "Bodies1", ids: [1,2,3,4], type: 1},
                {name: "Armors1", ids : [0,1,10,11,12,13,14,15,16,17,18,19,2], type:2},
                {name: "Armors2", ids : [20,21,22,23,24,25,26,27,28,29], type:2},
                {name: "Armors3", ids : [3,30,31,32,33,34,35,4,5,6,7,8,9], type:2},
                {name: "Mainhands1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22], type:3},
                {name: "Mainhands2", ids : [23,24,25,26,27,28,29,3,30,31], type:3},
                {name: "Mainhands3", ids : [32,33,34,35,4,5,6,7,8,9,0], type:3},
                {name: "Offhands1", ids : [0,1,10,11,12,13,14,15,16,17,18,19,2,20,21,22], type:4},
                {name: "Offhands2", ids : [23,24,25,26,27,28,29,3,30,31], type:4},
                {name: "Offhands3", ids : [32,33,34,35,4,5,6,7,8,9,0], type:4},
                {name: "Faces1", ids: [1,2,3,4,5,6,7,8,9,10], type:5},
                {name: "Faces2", ids: [11,12,13,14,15,16,17,18,19,20], type:5},
                {name: "Faces3", ids: [21,22,23,24,25,26,27,28,29,30], type:5},
                {name: "Faces4", ids: [31,32,33,34,35,36,37,38,39,40], type:5},
                {name: "Boots1", ids: [1,10,11,12,13,14,15,16,17,18,19,2,20,21], type:6},
                {name: "Boots2", ids: [22,23,24,25,3,4,5,6,7,8,9], type:6},
                {name: "Shirts1", ids: [1,10,11,12,13,14,15,16,17,2], type:7},
                {name: "Shirts2", ids: [20,18,19,3,4,5,6,7,8,9], type:7},
                {name: "Pants1", ids: [1,10,11,13,14,16,17,19,2,20,21], type:8},
                {name: "Pants2", ids: [12,15,18,3,4,5,6,7,8,9], type:8},
                {name: "Hairs1", ids: [1,10,11,12,13,14,15,16,17,19], type:9},
                {name: "Hairs2", ids: [2,20,21,3,4,5,6,7,8,9], type:9},
            ]

  
  for (let index = 0; index < svgs.length; index++) {
    console.log("Deploying", svgs[index].name);
    const FAC = await hre.ethers.getContractFactory(svgs[index].name);
    let data = await FAC.deploy();

    await data.deployed()
    console.log("address", data.address)
    if (svgs[index].type == 1) {
      console.log("Setting as Bodies")
      await inv.setBodies(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 2) {
      console.log("Setting as Armors")
      await inv.setArmors(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 3) {
      console.log("Setting as Mainhands")
      await inv.setMainhands(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 4) {
      console.log("Setting as Offhands")
      await inv.setOffhands(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 5) {
      console.log("Setting as Faces")
      await inv.setFaces(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 6) {
      console.log("Setting as Boots")
      await inv.setBoots(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 7) {
      console.log("Setting as Shirts")
      await inv.setShirts(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 8) {
      console.log("Setting as Pants")
      await inv.setPants(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 9) {
      console.log("Setting as Hairs")
      await inv.setHairs(svgs[index].ids, data.address)
    }


  } //end for loop

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
