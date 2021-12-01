// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {

  await hre.run("compile");

  // Deploy Orcs
  // console.log("Deploying Orcs")
  // let orc = await hre.ethers.getContractAt("EtherOrcs", "0x84698a8EE5B74eB29385134886b3a182660113e4");
  // console.log(orc.address)
  
  // await orc.deployed();

  console.log("Deploying Inv Manager")
  const InventoryManagerFactory = await hre.ethers.getContractFactory("InventoryManager");
  let invMan = await InventoryManagerFactory.deploy();
  console.log(invMan.address)

  console.log("Deploying Proxy")
  const ProxyFac = await hre.ethers.getContractFactory("Proxy");
  let pp = await ProxyFac.deploy(invMan.address);
  console.log(pp.address)

  await invMan.deployed();
  await pp.deployed();

  // await orc.setAddresses(pp.address, list.address);

  let inv = await hre.ethers.getContractAt("InventoryManager", pp.address)


  // Now deploy all of the art
  
  let svgs = [{name: "Bodies1", ids: [1,10,11,12,13,14,15,16,17,18,19,2, 20], type: 1},
              {name: "Bodies2", ids: [21,22,23,24,25,26,27,3,4,5,6,7,8,9], type:1},
              {name: "Helms1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24,25,26,27], type:2},
              {name: "Helms2", ids : [28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,5,6,7,8,9], type:2},
              {name: "Mainhands1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24,25,26,27], type:3},
              {name: "Mainhands2", ids : [28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,5,6,7,8,9], type:3},
              {name: "Offhands1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24,25,26,27], type:4},
              {name: "Offhands2", ids : [28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,5,6,7,8,9], type:4},
              {name: "Uniques", ids : [41,42,43,44,45,46,47,48,49,50,51,52], type:5}

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
      console.log("Setting as Helms")
      await inv.setHelms(svgs[index].ids, data.address)
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
      console.log("Setting as Uniques")
      await inv.setUniques(svgs[index].ids, data.address)
    }
  } //end for loop

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
