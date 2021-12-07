require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version:"0.8.7",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      } 
    }
  },
  networks: {
    hardhat: {
      accounts:
        [{privateKey: process.env.PRIVATE_KEY, balance: "10000000000000000000000000000000"}]
    },
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts:[process.env.PRIVATE_KEY],
    },
    goerli : {
      url: process.env.GOERLI_URL,
      accounts:[process.env.GOERLI_KEY],
    },
    mumbai : {
      url: process.env.MUMBAI_URL,
      accounts:[process.env.GOERLI_KEY],
      gasPrice: 30000000000,
    },
    polygon : {
      url: process.env.POLYGON_URL,
      accounts:[process.env.POLYGON_KEY],
      gasPrice: 40000000000,
      // gasLimit: 5000000,
    }
  },
   paths: {
    sources: "./src",
  },
};