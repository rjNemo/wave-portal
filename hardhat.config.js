require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        console.log(account.address);
    }
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
    solidity: "0.8.4",
    networks: {
        rinkeby: {
            url: process.env.STAGING_ALCHEMY_URL,
            accounts: [process.env.PRIVATE_KEY],
        },
        mainnet: {
            url: process.env.PROD_ALCHEMY_URL,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
};
