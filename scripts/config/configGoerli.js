// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function mintOrcs() {
	let orcs = await hre.ethers.getContractAt(
		"Rinkorc",
		"0xF5e0b0440ca25Bfe8d04323628d67EafBc94B7Cb"
	);

	for (let i = 0; i < 5051 - 100; i += 100) {
		await orcs.initMint(orcs.address, i, i + 100);
	}
}

async function main() {
	await hre.run("compile");

	let portalMain = "0x4F027dDa8320e192eAfF7a81D85B644705532465";
	let portalPoly = "0xE5B8F12c9FC0DB0b56A8e8EF0f6025F1C6770401";

	let alliesPoly = "0x31d5CdDEfFb400634362411a770443dD13000dF0";
	let castlePoly = "0x5a035d0c1E023dECa259E2450cA476dD6d2b2d3e";
	let zugPoly = "0xc6125F82cE43FebE06128369C3fA2A00B1654491";
	let boneShardsPoly = "0xC1B3D6d1Bf068d33389b69B3897ffb697eD84Bc9";
	let orcsPoly = "0x9Ee5F6C8B02908a29f111cA9B7B93e61d2374ab1";

	let alliesMain = "0xf714249B531c75e3C915b1C14677FE82399Be05e";
	let castleMain = "0x78A665c21203537aE336b6D42e623337A8844f17";
	let zugMain = "0x5353AF7Ba65Adb80976cc2aA826bE2753DDB9d7D";
	let boneShardsMain = "0x8B2f425841F6829F7161E4EAb076C613DbEE9DB8";
	let orcsMain = "0xF5e0b0440ca25Bfe8d04323628d67EafBc94B7Cb";

	// Config everything
	console.log("Starting config");
	await mintOrcs();
	//   let portal = await hre.ethers.getContractAt("MainlandPortal", portalMain)
	//   await portal.initialize(
	// 	"0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA",
	// 	"0x2890bA17EfE978480615e330ecB65333b880928e",
	// 	portalPoly
	// );
	// let c = await portal.setAuth([castleAddress], true);

	let allies = await hre.ethers.getContractAt("EtherOrcsAllies", alliesMain);
	let zug = await hre.ethers.getContractAt("Zug", zugMain);
	let shr = await hre.ethers.getContractAt("BoneShards", boneShardsMain);

	// await allies.setAuth("0x3FE61420C33b0E41DDd763adaAeB0b638E78b768", true)
	// await allies.setAuth("0x75c675e9B1767d5ca7F3F0187CADf93889Ac0d9A", true)
	// await allies.setAuth("0x6E4C0e63cCA268b0340e5c10f4758044c0a1Fa0A", true)
	// await allies.setAuth("0x5F6810DA9379D650676A4452f3415ce743FEfe14", true)
	// await allies.setAuth("0x1fEb609755F7C7d1dd4C05bf2589552Ed1217fe7", true)

	// await zug.setMinter("0x3FE61420C33b0E41DDd763adaAeB0b638E78b768", true)
	// await zug.setMinter("0x75c675e9B1767d5ca7F3F0187CADf93889Ac0d9A", true)
	// await zug.setMinter("0x6E4C0e63cCA268b0340e5c10f4758044c0a1Fa0A", true)
	// await zug.setMinter("0x5F6810DA9379D650676A4452f3415ce743FEfe14", true)
	// await zug.setMinter("0x1fEb609755F7C7d1dd4C05bf2589552Ed1217fe7", true)

	// await shr.setMinter("0x3FE61420C33b0E41DDd763adaAeB0b638E78b768", true)
	// await shr.setMinter("0x75c675e9B1767d5ca7F3F0187CADf93889Ac0d9A", true)
	// await shr.setMinter("0x6E4C0e63cCA268b0340e5c10f4758044c0a1Fa0A", true)
	// await shr.setMinter("0x5F6810DA9379D650676A4452f3415ce743FEfe14", true)
	// await shr.setMinter("0x1fEb609755F7C7d1dd4C05bf2589552Ed1217fe7", true)

	// await orc.setZug(zugAddress);
	// await orc.setCastle(castleAddress)
	// let t = await orc.setRaids(raidsAddress)
	// console.log(t)
	// await orc.setAuth(castleAddress, true)
	// console.log("done orc")

	// let hall = await hre.ethers.getContractAt("HallOfChampionsPolygon", hallAddress)
	// // await hall.setAddresses(orcAddress, zugAddress);
	// console.log("don hall")

	// let zug = await hre.ethers.getContractAt("PolyZug", zugAddress)
	// await zug.setMinter(castleAddress, true)
	// await zug.setMinter(orcAddress, true)
	// await zug.setMinter(hallAddress, true)
	// await zug.setMinter(raidsAddress, true)
	// console.log("done zug")

	// raids = await hre.ethers.getContractAt("PolyRaids", raidsAddress)
	// await raids.initialize(orcAddress, zugAddress, shrAddress, hallAddress)
	// console.log("done raids")

	// let shr = await hre.ethers.getContractAt("PolyBoneShards", shrAddress)
	// await shr.setMinter(castleAddress, true);
	// await shr.setMinter(raidsAddress, true);
	// console.log("done bonesdhards")

	// let proxyCastle = await hre.ethers.getContractAt("Castle", castleAddress);
	// await proxyCastle.initialize(portalAddress, orcAddress, zugAddress, shrAddress)
	// console.log("done castle")

	//   castle = await hre.ethers.getContractAt("Castle", castleMain);
	// await castle.setReflection(castleMain, castlePoly);
	// await castle.setReflection(portalMain, portalPoly);
	// await castle.setReflection(zugMain, zugPoly);
	// await castle.setReflection(boneShardsPoly, boneShardsMain);
	// await castle.setReflection(orcsMain, orcsPoly);
	// await castle.setReflection(alliesMain, alliesPoly);

	// for (let i = 0; i < 5051; i += 505) {
	//   await allies.initMint(castlePoly, i, i + 505)
	// }
	// console.log("inited")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
