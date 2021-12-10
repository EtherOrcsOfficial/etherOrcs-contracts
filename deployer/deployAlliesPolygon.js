// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
	await hre.run("compile");

	// console.log(AlliesFactory.deploy)
	let alliesImpl = await (
		await hre.ethers.getContractFactory("EtherOrcsAlliesPoly")
	).deploy();
	await alliesImpl.deployed();
	console.log("Allies_impl:", alliesImpl.address);

	let allies = await (
		await hre.ethers.getContractFactory("Proxy")
	).deploy(alliesImpl.address);
	await allies.deployed();
	console.log("Allies: ", allies.address);

	// Config everything
	console.log("Starting config");

	allies = await hre.ethers.getContractAt("MumbaiAllies", allies.address);
	await allies.setCastle(castle.address);
	await allies.setRaids(raids.address);
	await allies.setAuth(castle.address, true);
	console.log("done allies");

	let shr = await hre.ethers.getContractAt(
		"PolyShards",
		"0x62Add2b8Ff6E7a35720A001B40C22588D584FD13"
	);

	await shr.setMinter(allies.address, true);
	console.log("done bonesdhards");

	let proxyCastle = await hre.ethers.getContractAt("Castle", castle.address);
	await proxyCastle.setAllies(allies.address);
	console.log("done castle");
	for (let i = 5051; i < 8051 - 500; i += 500) {
		await allies.initMint(proxyCastle.address, i, i + 505);
	}
	console.log("inited");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
