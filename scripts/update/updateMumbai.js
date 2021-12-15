const PROXIES = {
	PolyOrcs: "0x9Ee5F6C8B02908a29f111cA9B7B93e61d2374ab1",
	MumbaiAllies: "0x31d5CdDEfFb400634362411a770443dD13000dF0",
	Castle: "0x5a035d0c1E023dECa259E2450cA476dD6d2b2d3e",
	RaidsPoly: "0x88720b5f026f0905d40664E185Ef3081Bd420d5B",
	PolylandPortal: "0xE5B8F12c9FC0DB0b56A8e8EF0f6025F1C6770401",
	EtherOrcsItems: "0xD7E2cC5C5d2c20216dfCd0b915480Ef2a1171f53",
	PotionVendorPoly: "0xf714249B531c75e3C915b1C14677FE82399Be05e",
	GamingOracle: "0x78A665c21203537aE336b6D42e623337A8844f17",
	InventoryManagerAllies: "0x436c522E0db1382aF6C1bCC9a6d610704cFBAfF2",
};

task("update", "Update a contract implementation")
	.addParam(
		"contract",
		`Contract name. One of: ${Object.keys(PROXIES).join(" ")}`
	)
	.setAction(async (args, { ethers, run }) => {
		run("compile");

		const { contract } = args;
		console.log("Deploying", contract);
		const implFact = await ethers.getContractFactory(contract);
		const impl = await implFact.deploy();
		console.log("Implementation: ", impl.address);

		console.log("Updating proxy");
		const proxy = await ethers.getContractAt("Proxy", PROXIES[contract]);

		await proxy.setImplementation(impl.address);
		console.log("Done updating");
	});
