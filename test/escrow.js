const escrow = artifacts.require("escrow");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("escrow", function ( accounts ) {
  it("should assert true", async function () {
    const [buyer, seller] = accounts;
    const escrow = await escrow.deployed();
    // await escrow.deployed();
    console.log(escrow);
    // return assert.isTrue(true);
  });
});
