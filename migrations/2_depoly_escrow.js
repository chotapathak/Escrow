// const escrow = artifacts.require("escrow");
var escrow = artifacts.require("../contracts/escrow.sol");

module.exports = async function (deployer,network, accounts) {
    deployer.then(async () => {
        deployer.deploy(escrow , accounts[0], {
            // from: accounts[0],
        });
    });
};

// main()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
//   });