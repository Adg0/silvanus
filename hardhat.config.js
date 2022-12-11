require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: '0.8.16',
	networks: {
		opt_goerli: {
			url: process.env.OPT_GOERLI_URL,
			accounts: [process.env.PRIVATE_KEY],
		},
		optimism: {
			url: process.env.OPT_URL,
			accounts: [process.env.PRIVATE_KEY],
		},
	},
};
