// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function deployInvManagerAlly() {
	console.log("Deploying Inv Manager");
	const InventoryManagerFactory = await hre.ethers.getContractFactory(
		"InventoryManagerAllies"
	);
	let invMan = await InventoryManagerFactory.deploy();
	console.log(invMan.address);

	console.log("Deploying Proxy");
	const ProxyFac = await hre.ethers.getContractFactory("Proxy");
	let pp = await ProxyFac.deploy(invMan.address);
	console.log(pp.address);

	let a = await hre.ethers.getContractAt("InventoryManagerAllies", pp.address);
	return a;
}

async function deployAllies() {
	console.log("Deploying Allies");
	const AlliesFact = await hre.ethers.getContractFactory("EtherOrcsAllies");
	let alliesImpl = await AlliesFact.deploy();
	console.log(alliesImpl.address);

	console.log("Deploying Proxy");
	const ProxyFac = await hre.ethers.getContractFactory("Proxy");
	let pp = await ProxyFac.deploy(alliesImpl.address);
	console.log(pp.address);

	let a = await hre.ethers.getContractAt("EtherOrcsAllies", pp.address);
	return [a, alliesImpl];
}

async function updateInvManagerAlly() {
	console.log("Deploying Inv Manager");
	const InventoryManagerFactory = await hre.ethers.getContractFactory(
		"InventoryManagerAllies"
	);
	let invMan = await InventoryManagerFactory.deploy();
	console.log(invMan.address);

	console.log("Updating Impl");
	let a = await hre.ethers.getContractAt(
		"Proxy",
		"0xd9A6538553e333E664c9816F78b68C5f2804e09f"
	);

	await a.setImplementation(invMan.address);
}

async function deployBoneShards() {
	// Getting BoneShards
	const BoneFact = await hre.ethers.getContractFactory("BoneShards");
	let shr = await BoneFact.deploy();
	await shr.deployed();
	console.log("BoneShards", shr.address);
	return shr;
}

// async function main() {

//   await hre.run("compile");

//   // Deploy Orcs
//   // console.log("Deploying Orcs")
//   // let orc = await hre.ethers.getContractAt("EtherOrcs", "0x84698a8EE5B74eB29385134886b3a182660113e4");
//   // console.log(orc.address)

//   // await orc.deployed();

//   let inv = await deployInvManagerAlly()
//   let shr = await deployBoneShards()
//   let ret = await deployAllies();

//   let allies = ret[0];
//   await allies.initialize(inv.address, shr.address, inv.address);

//   await shr.setMinter(allies.address, true);
//   await shr.setMinter("0x3FE61420C33b0E41DDd763adaAeB0b638E78b768",true);
//   await shr.setMinter("0x75c675e9B1767d5ca7F3F0187CADf93889Ac0d9A",true);
//   await shr.setMinter("0x6E4C0e63cCA268b0340e5c10f4758044c0a1Fa0A",true);
//   await shr.setMinter("0x5F6810DA9379D650676A4452f3415ce743FEfe14",true);
//   await shr.setMinter("0x1fEb609755F7C7d1dd4C05bf2589552Ed1217fe7",true);

//   // Now deploy all of the art

//   let svgs = [{name: "Bodies1", ids: [1,10,11,2,3], type: 1},
//               {name: "Bodies2", ids: [4,5,7,8,9], type:1},
//               {name: "FeatA", ids: [1,10,11,12,13,14,15,16,17,18,19,20,2,21,3,4,5,6,7,8,9], type:5},
//               {name: "FeatB", ids: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], type:6},
//               {name: "Helms1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32], type:2},
//               {name: "Helms2", ids : [33,34,35,36,37,38,39,4,40,41,42,43], type:2},
//               {name: "Helms3", ids : [44,45,46,47,48,49,5,50,6,7,8,9], type:2},
//               {name: "Mainhands1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24], type:3},
//               {name: "Mainhands2", ids : [25,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4], type:3},
//               {name: "Mainhands3", ids : [40,41,42,43,44,45,46,47,48,49,5,6,7,8,9], type:3},
//               {name: "Offhands1", ids : [1,10,11,12,13,14,15,16,17,18,19,2,20,21,22,23,24,25,26,27,28,29,3,30,31,32], type:4},
//               {name: "Offhands2", ids : [33,34,35,36,37,38,39,4,40,41,42], type:4},
//               {name: "Offhands3", ids : [43,44,45,46,47,48,49,5,50,6,7,8,9], type:4}
//             ]

//   for (let index = 0; index < svgs.length; index++) {
//     console.log("Deploying", svgs[index].name);
//     const FAC = await hre.ethers.getContractFactory(svgs[index].name);
//     let data = await FAC.deploy();

//     await data.deployed()
//     console.log("address", data.address)
//     if (svgs[index].type == 1) {
//       console.log("Setting as Bodies")
//       await inv.setBodies(svgs[index].ids, data.address)
//     }

//     if (svgs[index].type == 2) {
//       console.log("Setting as Helms")
//       await inv.setHelms(svgs[index].ids, data.address)
//     }

//     if (svgs[index].type == 3) {
//       console.log("Setting as Mainhands")
//       await inv.setMainhands(svgs[index].ids, data.address)
//     }

//     if (svgs[index].type == 4) {
//       console.log("Setting as Offhands")
//       await inv.setOffhands(svgs[index].ids, data.address)
//     }

//     if (svgs[index].type == 5) {
//       console.log("Setting as featA")
//       await inv.setFeatA(svgs[index].ids, data.address)
//     }

//     if (svgs[index].type == 6) {
//       console.log("Setting as featB")
//       await inv.setFeatB(svgs[index].ids, data.address)
//     }
//   } //end for loop

//     await hre.run("verify:verify", {
// 			address: allies.address,
// 		});
// 		await hre.run("verify:verify", {
// 			address: shr.address,
// 		});
// 		await hre.run("verify:verify", {
// 			address: inv.address,
// 		});
// 		await hre.run("verify:verify", {
// 			address: ret[1].address,
// 		});
// }

async function main() {
	await hre.run("compile");

	await updateInvManagerAlly();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
