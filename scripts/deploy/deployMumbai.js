// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const VERIFY = hre.network.name !== "localhost";

const MUMBAI_FX_ROOT = "0xCf73231F28B7331BBe3124B907840A94851f9f11"

async function main() {
	console.log(hre.config.solidity.compilers[0]);
	await hre.run("compile");

	const ProxyFac = await hre.ethers.getContractFactory("Proxy");

	// Orcs Deployment
	console.log("Deploying Orcs");
	const OrcFac = await hre.ethers.getContractFactory("PolyOrc");
	let orcImpl = await OrcFac.deploy();
	await orcImpl.deployed();
	console.log("Orc_impl:", orcImpl.address);

	let orc = await ProxyFac.deploy(orcImpl.address);
	await orc.deployed();
	console.log("Orc: ", orc.address);

	// Allies Deployment
	console.log("Deploying Allies");
	const AllyFac = await hre.ethers.getContractFactory("MumbaiAllies");
	let allyImpl = await AllyFac.deploy();
	await allyImpl.deployed();
	console.log("Ally_impl:", allyImpl.address);

	let allies = await ProxyFac.deploy(allyImpl.address);
	await allies.deployed();
	console.log("Ally: ", allies.address);

	// Deploying castle
	console.log("Deploying Castle");
	const CastleFactory = await hre.ethers.getContractFactory("Castle");
	let castleImpl = await CastleFactory.deploy();
	console.log("Castle_impl:", castleImpl.address);

	let castle = await ProxyFac.deploy(castleImpl.address);
	await castle.deployed();
	console.log("Castle:", castle.address);

	//Deploying Raids
	console.log("Deploying Raids");
	const RaidsFact = await hre.ethers.getContractFactory("RaidsPoly");
	let raidsImpl = await RaidsFact.deploy();
	await raidsImpl.deployed();
	console.log("Raids_impl:", raidsImpl.address);

	let raids = await ProxyFac.deploy(raidsImpl.address);
	console.log("Raids:", raids.address);

	// Getting existing Portal
	const PortalFactory = await hre.ethers.getContractFactory("PolylandPortal");
	let portalImpl = await PortalFactory.deploy();
	await portalImpl.deployed();
	console.log("Portal_impl: ", portalImpl.address);

	let portal = await ProxyFac.deploy(portalImpl.address);
	await portal.deployed();
	console.log("Portal:", portal.address);

	// Getting Items Contract
	const ItemsFactory = await hre.ethers.getContractFactory("EtherOrcsItems");
	let itemsImpl = await ItemsFactory.deploy();
	await itemsImpl.deployed();
	console.log("items_impl: ", itemsImpl.address);

	let items = await ProxyFac.deploy(itemsImpl.address);
	await items.deployed();
	console.log("items:", items.address);

	// Getting Zug
	const ZugFac = await hre.ethers.getContractFactory("ZugPoly");
	let zug = await ZugFac.deploy();
	await zug.deployed();
	console.log("Zug:", zug.address);

	// Getting BoneShards
	const BoneFact = await hre.ethers.getContractFactory("BoneShardsPoly");
	let shr = await BoneFact.deploy();
	await shr.deployed();
	console.log("BoneShards", shr.address);

	// getting Hall of Champions
	const HallFact = await hre.ethers.getContractFactory("HallOfChampionsPoly");
	let hallImpl = await HallFact.deploy();
	await hallImpl.deployed();
	console.log("Hall_impl: ", hallImpl.address);

	let hall = await ProxyFac.deploy(hallImpl.address);
	await hall.deployed();
	console.log("Hall: ", hall.address);


	//Deploy Potion Vendor
	const PotionVendorFact = await hre.ethers.getContractFactory("PotionVendorPoly");
	let potionVendorImpl = await PotionVendorFact.deploy();
	await potionVendorImpl.deployed();
	console.log("PotionVendor_impl: ", potionVendorImpl.address);

	let potionVendor = await ProxyFac.deploy(potionVendorImpl.address);
	await potionVendor.deployed();
	console.log("PotionVendor: ", potionVendor.address);

	//Deploy Gaming Oracle
	const GamingOracleFact = await hre.ethers.getContractFactory("GamingOraclePoly");
	let gamingOracleImpl = await GamingOracleFact.deploy();
	await gamingOracleImpl.deployed();
	console.log("GamingOracle_impl: ", gamingOracleImpl.address);

	let gamingOracle = await ProxyFac.deploy(gamingOracleImpl.address);
	await gamingOracle.deployed();
	console.log("GamingOracle: ", gamingOracle.address);

	// Config everything
	console.log("Starting config");

	portal = await hre.ethers.getContractAt("PolylandPortal", portal.address);
	await portal.initialize(
		"0xCf73231F28B7331BBe3124B907840A94851f9f11",
		portal.address
	);
	console.log("done portal");

	orc = await hre.ethers.getContractAt("EtherOrcsPoly", orc.address);
	await orc.setCastle(castle.address);
	await orc.setRaids(raids.address);
	await orc.setZug(zug.address);
	await orc.setAuth(castle.address, true);
	await orc.setAuth(raids.address, true);
	console.log("done orc");

	allies = await hre.ethers.getContractAt("MumbaiAllies", allies.address);

	await allies.initialize(zug.address, shr.address, items.address, raids.address, castle.address, gamingOracle.address);
	await allies.setAuth(castle.address, true);
	await allies.setAuth(raids.address, true);
	console.log("done allies");
 
	await zug.setMinter(castle.address, true);
	await zug.setMinter(allies.address, true);
	await zug.setMinter(orc.address, true);
	await zug.setMinter(hall.address, true);
	await zug.setMinter(raids.address, true);
	console.log("done zug");

	raids = await hre.ethers.getContractAt("RaidsPoly", raids.address);
	await raids.initialize(orc.address, zug.address, shr.address, hall.address);
	await raids.init(allies.address, potionVendor.address, items.address);
	console.log("done raids");

	await shr.setMinter(castle.address, true);
	await shr.setMinter(raids.address, true);
	await shr.setMinter(allies.address, true);
	console.log("done boneshards");

	items = await hre.ethers.getContractAt("EtherOrcsItems", items.address);
	await items.setMinter(allies.address, true);
	await items.setMinter(raids.address, true);
	console.log("done items")

	portal = await hre.ethers.getContractAt("PolylandPortal", portal.address);
	await portal.setAuth([castle.address], true)

	castle = await hre.ethers.getContractAt("Castle", castle.address);
	await castle.initialize(
		portal.address,
		orc.address,
		zug.address,
		shr.address
	);

	await castle.setAllies(allies.address);

	// await proxyCastle.setReflection(portal.address, portal.address);
	// await proxyCastle.setReflection(zug.address, zug.address);
	// await proxyCastle.setReflection(shr.address, shr.address);
	// await proxyCastle.setReflection(orc.address, orc.address);

	console.log("done castle");
	for (let i = 0; i < 5051; i += 505) {
		await orc.initMint(orc.address, i, i + 505);
		
	}

	//TODO 
	//initMint for allies

	console.log("inited");

	// verifying everything
	if (VERIFY) {
		await hre.run("verify:verify", {
			address: orcImpl.address,
		});
		await hre.run("verify:verify", {
			address: orc.address,
		});
		await hre.run("verify:verify", {
			address: castleImpl.address,
		});
		await hre.run("verify:verify", {
			address: castle.address,
		});
		await hre.run("verify:verify", {
			address: raidsImpl.address,
		});
		await hre.run("verify:verify", {
			address: raids.address,
		});
		await hre.run("verify:verify", {
			address: portalImpl.address,
		});
		await hre.run("verify:verify", {
			address: portal.address,
		});
		await hre.run("verify:verify", {
			address: zug.address,
		});
		await hre.run("verify:verify", {
			address: shr.address,
		});
		await hre.run("verify:verify", {
			address: hallImpl.address,
		});
		await hre.run("verify:verify", {
			address: hall.address,
		});
		await hre.run("verify:verify", {
			address: gamingOracle.address,
		});
		await hre.run("verify:verify", {
			address: potionVendor.address,
		});
		await hre.run("verify:verify", {
			address: items.address,
		});
		await hre.run("verify:verify", {
			address: allies.address,
		});
	}
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
