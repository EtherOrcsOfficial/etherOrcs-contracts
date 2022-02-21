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

    // let portalMain = "0x4F027dDa8320e192eAfF7a81D85B644705532465"
    // let portalPoly = "0xE5B8F12c9FC0DB0b56A8e8EF0f6025F1C6770401"
    
    // let alliesPoly    = "0x31d5CdDEfFb400634362411a770443dD13000dF0"
    // let castlePoly    = "0x5a035d0c1E023dECa259E2450cA476dD6d2b2d3e"
    // let zugPoly    = "0xc6125F82cE43FebE06128369C3fA2A00B1654491"
    // let boneShardsPoly    = "0xC1B3D6d1Bf068d33389b69B3897ffb697eD84Bc9"
    // let orcsPoly    = "0x9Ee5F6C8B02908a29f111cA9B7B93e61d2374ab1"

    // let alliesMain    = "0xf714249B531c75e3C915b1C14677FE82399Be05e"
    // let castleMain    = "0x78A665c21203537aE336b6D42e623337A8844f17"
    // let zugMain    = "0x5353AF7Ba65Adb80976cc2aA826bE2753DDB9d7D"
    // let boneShardsMain    = "0x8B2f425841F6829F7161E4EAb076C613DbEE9DB8"
    // let orcsMain    = "0xF5e0b0440ca25Bfe8d04323628d67EafBc94B7Cb"



let proxies  = {
    "EtherOrcsAllies": "0xf714249B531c75e3C915b1C14677FE82399Be05e"
}

async function main() {
  await hre.run("compile");

  await updateProxy("EtherOrcsAllies",proxies["EtherOrcsAllies"]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
