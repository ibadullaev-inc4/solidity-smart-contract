const {expect} = require("chai")
const {ethers} = require("hardhat")


describe("Demo", function() {
    let owner
    let other_addr
    let demo

    this.beforeEach(async function() {
        [owner, other_addr] = await ethers.getSigners()
        const DemoContract =  await ethers.getContractFactory("Demo", owner)
        demo = await DemoContract.deploy()
    })

    async function sendMoney(sender) {
        const amount = 100;
        const txData = { to: demo, value: amount }
        const tx = await sender.sendTransaction(txData)
        await tx.wait()
        return [tx, amount]
    } 

    it("should allow to send money", async function() {
        const [sendMoneyTx, amount] = await sendMoney(other_addr)
        await expect(() => sendMoneyTx).to.changeEtherBalance(demo, amount)
        const timestamp = (await ethers.provider.getBlock(sendMoneyTx.blockNumber)).timestamp
        // await expect(() => sendMoneyTx).to.emit(demo, "Paid").withArgs(other_addr, amount, timestamp)
    })

    it("should allow owner to withdrow funds", async function() {
        const [_,amount] = await sendMoney(other_addr)
        const tx = demo.withdrawOnlyOwner(owner)
        await expect(() => tx).to.changeEtherBalances([demo,owner],[-amount,amount])
    })

    it("should  not allow other accounts to withdrow funds", async function() {
        await sendMoney(other_addr)
        await expect(demo.connect(other_addr).withdrawOnlyOwner(other_addr)).to.be.rejectedWith("you are not an owner")
    })

})


