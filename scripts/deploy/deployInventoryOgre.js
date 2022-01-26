// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");


async function deployInvManagerOgre() {
    console.log("Deploying Inv Manager")
  const InventoryManagerFactory = await hre.ethers.getContractFactory("InventoryManagerOgres");
  let invMan = await InventoryManagerFactory.deploy();
  console.log(invMan.address)

  console.log("Deploying Proxy")
  const ProxyFac = await hre.ethers.getContractFactory("Proxy");
  let pp = await ProxyFac.deploy(invMan.address);
  console.log(pp.address)

  let a = await hre.ethers.getContractAt("InventoryManagerOgres", pp.address);
  return a;
}

async function main() {

  await hre.run("compile");

  // Deploy Orcs
  // console.log("Deploying Orcs")
  // let orc = await hre.ethers.getContractAt("EtherOrcs", "0x84698a8EE5B74eB29385134886b3a182660113e4");
  // console.log(orc.address)
  
  // await orc.deployed();


  let inv = await deployInvManagerOgre()


  // Now deploy all of the art
    let svgs = [{name: "Bodies1", ids: [1,2,3,4], type: 1},
              {name: "Bodies2", ids: [5,6,7,8], type:1},
              {name: "Mouths1", ids: [1,10,11,12,13,14,15,16,17,18,19,2], type:5},
              {name: "Mouths2", ids: [20,21,22,23,24,3,4,5,6,7,8,9], type:5},
              {name: "Noses1", ids: [1,10,11,12,13,14,15,16,17,18,19,2], type:6},
              {name: "Noses2", ids: [20,21,22,23,24,3,4,5,6,7,8,9], type:6},
              {name: "Eyes1", ids: [1,10,11,12,13,14,15,16,17,18,19,2], type:7},
              {name: "Eyes2", ids: [20,21,22,23,24,3,4,5,6,7,8,9], type:7},
              {name: "Armors1", ids : [10,11,12,13,14,15,16,17,18,19], type:2},
              {name: "Armors2", ids : [20,21,22,23,24,25,26,27,28,29], type:2},
              {name: "Armors3", ids : [30,31,32,33,34,35,1,2,3,4,5,6,7,8,9], type:2},
              {name: "Mainhands1", ids : [1,10,11,12,13,14,15,16,17,18,19,2], type:3},
              {name: "Mainhands2", ids : [20,21,22,23,24,25,26,27,28,29,3,30,31], type:3},
              {name: "Mainhands3", ids : [32,33,34,35,4,5,6,7,8,9], type:3},
              {name: "Offhands1", ids : [1,10,11,12,13,14,15,16,17,18,19], type:4},
              {name: "Offhands2", ids : [2,20,21,22,23,24,25,26,27,28,29,3], type:4},
              {name: "Offhands3", ids : [30,31,32,33,34,35,4,5,6,7,8,9], type:4}
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
      console.log("Setting as Mouths")
      await inv.setMouths(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 6) {
      console.log("Setting as Noses")
      await inv.setNoses(svgs[index].ids, data.address)
    }

    if (svgs[index].type == 7) {
      console.log("Setting as Eyes")
      await inv.setEyes(svgs[index].ids, data.address)
    }

  } //end for loop

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
