// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
	console.log(hre.config.solidity.compilers[0]);
	await hre.run("compile");

	const ProxyFac = await hre.ethers.getContractFactory("Proxy");

	// Orcs Deployment
	console.log("Deploying Orcs");
	const OrcFac = await hre.ethers.getContractFactory("Rinkorc");
	let orcImpl = await OrcFac.deploy();
	await orcImpl.deployed();
	console.log("Orc_impl:", orcImpl.address);
	await hre.run("verify:verify", {
		address: orcImpl.address,
	});

	let orc = await ProxyFac.deploy(orcImpl.address);
	await orc.deployed();
	console.log("Orc: ", orc.address);
	await hre.run("verify:verify", {
		address: orc.address,
	});

	// Deploying castle
	console.log("Deploying Castle");
	const CastleFactory = await hre.ethers.getContractFactory("Castle");
	let castleImpl = await CastleFactory.deploy();
	console.log("Castle_impl:", castleImpl.address);
	await hre.run("verify:verify", {
		address: castleImpl.address,
	});

	let castle = await ProxyFac.deploy(castleImpl.address);
	await castle.deployed();
	console.log("Castle:", castle.address);
	await hre.run("verify:verify", {
		address: castle.address,
	});

	//Deploying Raids
	console.log("Deploying Raids");
	const RaidsFact = await hre.ethers.getContractFactory("Raids");
	let raidsImpl = await RaidsFact.deploy();
	await raidsImpl.deployed();
	console.log("Raids_impl:", raidsImpl.address);
	await hre.run("verify:verify", {
		address: raidsImpl.address,
	});

	let raids = await ProxyFac.deploy(raidsImpl.address);
	console.log("Raids:", raids.address);
	await hre.run("verify:verify", {
		address: raids.address,
	});

	// Getting existing Portal
	const PortalFactory = await hre.ethers.getContractFactory("MainlandPortal");
	let portalImpl = await PortalFactory.deploy();
	await portalImpl.deployed();
	console.log("Portal_impl: ", portalImpl.address);
	await hre.run("verify:verify", {
		address: portalImpl.address,
	});

	let portal = await ProxyFac.deploy(portalImpl.address);
	await portal.deployed();
	console.log("Portal:", portal.address);
	await hre.run("verify:verify", {
		address: portal.address,
	});

	// Getting Zug
	const ZugFac = await hre.ethers.getContractFactory("ERC20");
	let zug = await ZugFac.deploy();
	await zug.deployed();
	console.log("Zug:", zug.address);
	await hre.run("verify:verify", {
		address: zug.address,
	});

	// Getting BoneShards
	const BoneFact = await hre.ethers.getContractFactory("BoneShards");
	let shr = await BoneFact.deploy();
	await shr.deployed();
	console.log("BoneShards", shr.address);
	await hre.run("verify:verify", {
		address: shr.address,
	});

	// getting Hall of Champions
	const HallFact = await hre.ethers.getContractFactory("HallOfChampions");
	let hallImpl = await HallFact.deploy();
	await hallImpl.deployed();
	console.log("Hall_impl: ", hallImpl.address);
	await hre.run("verify:verify", {
		address: hallImpl.address,
	});

	let hall = await ProxyFac.deploy(hallImpl.address);
	await hall.deployed();
	console.log("Hall: ", hall.address);
	await hre.run("verify:verify", {
		address: hall.address,
	});

	// Config everything
	console.log("Starting config");

	portal = await hre.ethers.getContractAt("MainlandPortal", portal.address);
	await portal.setAuth([castle.address], true);
	await portal.initialize(
		"0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA",
		"0x2890bA17EfE978480615e330ecB65333b880928e",
		portal.address
	);

	orc = await hre.ethers.getContractAt("Rinkorc", orc.address);
	await orc.setCastle(castle.address);
	await orc.setRaids(raids.address);
	await orc.setZug(zug.address);
	await orc.setAuth(castle.address, true);
	console.log("done orc");

	hall = await hre.ethers.getContractAt("HallOfChampions", hall.address);
	await hall.setAddresses(orc.address, zug.address);
	console.log("done hall");

	await zug.setMinter(castle.address, true);
	await zug.setMinter(orc.address, true);
	await zug.setMinter(hall.address, true);
	await zug.setMinter(raids.address, true);
	console.log("done zug");

	raids = await hre.ethers.getContractAt("Raids", raids.address);
	await raids.initialize(orc.address, zug.address, shr.address, hall.address);
	console.log("done raids");

	await shr.setMinter(castle.address, true);
	await shr.setMinter(raids.address, true);
	console.log("done boneshards");

	let proxyCastle = await hre.ethers.getContractAt("Castle", castle.address);
	await proxyCastle.initialize(
		portal.address,
		orc.address,
		zug.address,
		shr.address
	);
	await proxyCastle.setReflection(portal.address, portal.address);
	await proxyCastle.setReflection(zug.address, zug.address);
	await proxyCastle.setReflection(shr.address, shr.address);
	await proxyCastle.setReflection(orc.address, orc.address);
	console.log("done castle");
	for (let i = 0; i < 5051; i += 505) {
		await orc.initMint(orc.address, i, i + 505);
	}
	console.log("inited");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
