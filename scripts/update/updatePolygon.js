// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

const worldAddress = "0x7b246FB2EE61E99B60ad123d2C59c6d311Cc94Ea";

async function updateProxy(contractName, address) {
    console.log("Deploying", contractName)
    const ImplFact = await hre.ethers.getContractFactory(contractName);
    let impl = await ImplFact.deploy();
    console.log(impl.address)
    await impl.deployed();

    console.log("Updating Impl")
    let a = await hre.ethers.getContractAt("Proxy", address);

    await a.setImplementation(impl.address);

    let im = await hre.ethers.getContractAt(contractName, address);
    return im;
}

let proxies  = {
    "EtherOrcsItems": "0xd769705e0F6265F12c13CE85aEB7a1218D655cfD",
    "EtherOrcsAlliesPoly": "0xbFF91E8592e5Ba6A2a3e035097163A22e8f9113A",
    "EtherOrcsPoly": "0x84698a8EE5B74eB29385134886b3a182660113e4",
    "Castle": "0xaF8884f29a4421d7CA847895Be4d2edE40eD6ad9",
    "RaidsPoly": "0x2EeC5C9DfD2a8630fBAa8973357a9ac8393721D4",
    "PotionVendor": "0xBb477E51A4E28280cB1839cb2F8AB551b24834Ae",
    "InventoryManagerAllies": "0xa44dE708c9a79A9465463C08f2980077b0808B06",
    "InventoryManagerOgres": "0x0Ad561F3E4a39c72e0AEE345D1590600F22cE1b2",
    "InventoryManagerRogues": "0x39eb2084Cfc89b44A036cDd81d2aE97B7eFFa4FF",
    "InventoryManagerItems": "0x6e0c15a29851814D0e88E4AeaA359bae67e89676",
    "HordeUtilities": "0x6FFFa8692B29e982B9668B35ed998570BeB64C79",
    "GamingOraclePoly": "0x04A0B7E35828c985e78E2F1107e0B1C3FE39a837",
}

async function main() {
    await hre.run("compile");

    const orcs = await updateProxy("EtherOrcsPoly", proxies["EtherOrcsPoly"]);
    const allies = await updateProxy("EtherOrcsAlliesPoly", proxies["EtherOrcsAlliesPoly"]);

    console.log("Setting world address on Orcs contract...");
    await(await orcs.setWorld(worldAddress)).wait();

    console.log("Setting world address on Allies contract...");
    await(await allies.setWorld(worldAddress)).wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
