// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");



async function updateProxy(contractName, address) {
    console.log("Deploying", contractName)
  const ImplFact = await hre.ethers.getContractFactory(contractName);
  let impl = await ImplFact.deploy();
  console.log(impl.address)

  console.log("Updating Impl")
  let a = await hre.ethers.getContractAt("Proxy", address);

  await a.setImplementation(impl.address);
}



let proxies  = {
    "PolyOrcs": "0x9Ee5F6C8B02908a29f111cA9B7B93e61d2374ab1",
    "MumbaiAllies": "0x31d5CdDEfFb400634362411a770443dD13000dF0",
    "Castle": "0x5a035d0c1E023dECa259E2450cA476dD6d2b2d3e",
    "RaidsPoly": "0x88720b5f026f0905d40664E185Ef3081Bd420d5B",
    "PolylandPortal": "0xE5B8F12c9FC0DB0b56A8e8EF0f6025F1C6770401",
    "EtherOrcsItems": "0xD7E2cC5C5d2c20216dfCd0b915480Ef2a1171f53",
    "PotionVendorPoly": "0xf714249B531c75e3C915b1C14677FE82399Be05e",
    "GamingOraclePoly": "0x78A665c21203537aE336b6D42e623337A8844f17",
    "InventoryManagerAllies": "0x436c522E0db1382aF6C1bCC9a6d610704cFBAfF2"
}

async function main() {
  await hre.run("compile");

  // await updateProxy("MumbaiAllies",proxies["MumbaiAllies"]);
  // await updateProxy("RaidsPoly",proxies["RaidsPoly"]);
  await updateProxy("Castle",proxies["Castle"]);
  // await updateProxy("EtherOrcsItems", proxies["EtherOrcsItems"]);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
