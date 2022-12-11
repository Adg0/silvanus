const { ethers } = require('hardhat');

async function main() {
	const WaterToken = await ethers.getContractFactory('WaterToken');
	const waterToken = await WaterToken.deploy();

	try {
		await waterToken.deployed();
		console.log('Created H2O, deployed to: ', waterToken.address);
	} catch (err) {
		console.log('Error: ', err.message);
	}
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
