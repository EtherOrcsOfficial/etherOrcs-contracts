require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

// Keys
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RINKEBY_KEY = process.env.RINKEBY_KEY;
const GOERLI_KEY = process.env.GOERLI_KEY;
const MUMBAI_KEY = process.env.GOERLI_KEY;
const POLYGON_KEY = process.env.POLYGON_KEY;

// URLs
const MAINNET_URL = process.env.MAINNET_URL || "";
const RINKEBY_URL = process.env.RINKEBY_URL || "";
const GOERLI_URL = process.env.GOERLI_URL || "";
const MUMBAI_URL = process.env.MUMBAI_URL || "";
const POLYGON_URL = process.env.POLYGON_URL || "";

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
	solidity: {
		version: "0.8.7",
		settings: {
			optimizer: {
				enabled: true,
				runs: 200,
			},
		},
	},
	networks: {
		hardhat: {
			accounts: [
				{
					privateKey: PRIVATE_KEY,
					balance: "10000000000000000000000000000000",
				},
			],
		},
		rinkeby: {
			url: `${RINKEBY_URL}`,
			accounts: RINKEBY_KEY !== undefined ? [RINKEBY_KEY] : [],
		},
		goerli: {
			url: GOERLI_URL,
			accounts: GOERLI_KEY !== undefined ? [GOERLI_KEY] : [],
		},
		mumbai: {
			url: MUMBAI_URL,
			accounts: MUMBAI_KEY !== undefined ? [MUMBAI_KEY] : [],
		},
		polygon: {
			url: POLYGON_URL,
			accounts: POLYGON_KEY !== undefined ? [POLYGON_KEY] : [],
		},
		mainnet: {
			url: MAINNET_URL,
			accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
		},
	},
	etherscan: {
		// Your API key for Etherscan
		// Obtain one at https://etherscan.io/
		
		apiKey: process.env.ETHERSCAN_API_KEY
  	},

	paths: {
		sources: "./src",
		cache: "hh-cache",
	},
};
