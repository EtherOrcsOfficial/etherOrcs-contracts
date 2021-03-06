// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
	await hre.run("compile");
	const BONE_SHARDS = "0x6c716bDB4289283e0ad1926c47B54412Bd2C257B";
	const CASTLE = "0x2F3f840d17Eb61020680c1f4B00510c3CaA7dF63";
	const RAIDS = "0x47DC8e20C15f6deAA5cBFeAe6cf9946aCC89af59";
	const META = "0xf286aa8c83609328811319af2f223bcc5b6db028";

	// Allies implementation
	const _alliesFactory = await hre.ethers.getContractFactory(
		"EtherOrcsAllies"
	);
	const _allies = await _alliesFactory.deploy();
	await _allies.deployed();
	console.log("Allies_impl:", _allies.address);

	// Allies proxy deployment
	const alliesFactory = await hre.ethers.getContractFactory("Proxy");
	let allies = await alliesFactory.deploy(_allies.address);
	await allies.deployed();
	console.log("Allies: ", allies.address);

	// New castle implementation
	// Allies implementation
	const _castleFactory = await hre.ethers.getContractFactory(
		"Castle"
	);
	const _castle = await _castleFactory.deploy();
	await _castle.deployed();
	console.log("Castle_impl:", _castle.address);

	// Allies configuration
	console.log("Starting config");
	allies = await hre.ethers.getContractAt("EtherOrcsAllies", allies.address);

	await allies.initialize(CASTLE, BONE_SHARDS, META);
	await allies.setAuth(CASTLE, true);
	console.log("done allies");

	// Boneshards configuration
	const shr = await hre.ethers.getContractAt("BoneShards", BONE_SHARDS);
	await shr.setMinter(allies.address, true);
	console.log("done bonesdhards");

	// const proxyCastle = await hre.ethers.getContractAt("Castle", CASTLE);
	// await proxyCastle.setAllies(allies.address);
	// console.log("done castle");
	// console.log("allies init minting");
	// for (let i = 5051; i < 8051 - 500; i += 500) {
	// 	await allies.initMint(proxyCastle.address, i, i + 505);
	// }
	console.log("inited");

	await hre.run("verify:verify", {
		address: _allies.address,
	});

	await hre.run("verify:verify", {
		address: _castle.address,
	});

	await hre.run("verify:verify", {
		address: allies.address,
		constructorArguments: [_allies.address],
	});

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
