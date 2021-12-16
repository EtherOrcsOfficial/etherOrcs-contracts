// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function deployContract(contractName) {
	console.log("Deploying ", contractName);
	const _implFactory = await hre.ethers.getContractFactory(contractName);
	const _impl = await _implFactory.deploy();
	await _impl.deployed();
	console.log("_implFactory:", _impl.address);

	// Potion proxy deployment
	const proxyFactory = await hre.ethers.getContractFactory("Proxy");
	let proxy = await proxyFactory.deploy(_impl.address);
	await proxy.deployed();
	console.log(contractName, ": ", proxy.address);

	let instance = await hre.ethers.getContractAt(contractName, proxy.address);
	return instance
}

async function main() {
	await hre.run("compile");
	const BONE_SHARDS = "0x62Add2b8Ff6E7a35720A001B40C22588D584FD13";
	const CASTLE = "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9";
	const RAIDS = "0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4";
	const INVMANAGER = "0xA873dF562Eb39A3c560038Fc2c3D5b1C09C03b82";
	const ZUG = "0xeb45921FEDaDF41dF0BfCF5c33453aCedDA32441";

	let allies = await deployContract("EtherOrcsAlliesPoly");
	let potionVendor = await deployContract("PotionVendorPoly");
	let gamingOracle = await deployContract("GamingOraclePoly");
	let items = await deployContract("EtherOrcsItems");
	let itemsInvManager = await deployContract("InventoryManagerItems")

	// Allies configuration
	await allies.initialize(ZUG, BONE_SHARDS, items.address, RAIDS, CASTLE, gamingOracle.address);
	await allies.setMetadataHandler(INVMANAGER);
	await allies.setAuth(CASTLE, true);
	await allies.setAuth(RAIDS, true);
	console.log("done allies");

	// Token configuration
	const shr = await hre.ethers.getContractAt("BoneShardsPoly", BONE_SHARDS);
	await shr.setMinter(allies.address, true);
	console.log("done bonesdhards");

	const zug = await hre.ethers.getContractAt("ZugPoly", ZUG);
	await zug.setMinter(allies.address, true);
	console.log("done zug")

	await items.setMinter(allies.address, true);
	await items.setMinter(RAIDS, true);
	await items.setMinter(potionVendor.address, true);

	await items.setInventoryManager(itemsInvManager.address);
	console.log("done items")

	let link = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1"
	let vrfCorr = "0x3d2341ADb2D31f1c5530cDC622016af293177AE0"
	let keyHash = "0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da"
	
	// Config Gaming Oracle
	await gamingOracle.initialize(link, vrfCorr, keyHash);
	await gamingOracle.setAuth(RAIDS, true);
	await gamingOracle.setAuth(allies.address, true)
	console.log("done oracle")

	// Configure Potion Vendor
	await potionVendor.initialize(ZUG, items.address, 10);
	console.log("done potion")

	// Castle Update
	// const castle = await hre.ethers.getContractAt("Castle", CASTLE);
	// await castle.setAllies(allies.address);
	// console.log("done castle");

	console.log("allies init minting");
	for (let i = 5051; i < 8051 - 500; i += 500) {
		await allies.initMint(CASTLE, i, i + 500);
	}
	console.log("inited");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
