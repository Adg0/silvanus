require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: '0.8.17',
	networks: {
		url: process.env.OPT_GOERLI_URL,
		accounts: [process.env.PRIVATE_KEY],
	},
};