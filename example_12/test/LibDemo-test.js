const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("LibDemo", function() {
    let owner;
  
    beforeEach(async function () {
      [owner] = await ethers.getSigners();
  
      const LibDemo = await ethers.getContractFactory("LibDemo");
      demo = await LibDemo.deploy();
      await demo.deploymentTransaction().wait()
    });


    it("comares string", async function () { 
        expect(await demo.runnerStr("str","str")).to.eq(true);
        expect(await demo.runnerStr("str1","str2")).to.eq(false);
    });

    it("find element in array", async function () { 
        expect(await demo.runnerArr([10,12,20],12)).to.eq(true);
        expect(await demo.runnerArr([10,12,20],52)).to.eq(false);
    });

});