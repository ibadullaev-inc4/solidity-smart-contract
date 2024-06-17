const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Demo", function() {
    let owner;
    let demo;
    let logger;
  
    beforeEach(async function () {
      [owner] = await ethers.getSigners();
  
      const Logger = await ethers.getContractFactory("Logger");
      logger = await Logger.deploy();
      await logger.deploymentTransaction().wait()
  
      const Demo = await ethers.getContractFactory("Demo");
      demo = await Demo.deploy(logger.getAddress());
      await demo.deploymentTransaction().wait()
    });


    it('should send a transaction to the demo contract', async function () {
        const sum = 100;
        const txData = { value: sum, to: demo.getAddress() };
        const tx = await owner.sendTransaction(txData);
        await tx.wait();
        await expect(tx).to.changeEtherBalance(demo, sum);
        const amount = await demo.payment(owner.getAddress(), 0);
        expect(amount).to.eq(sum);
      });
});
