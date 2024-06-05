const {expect} = require("chai")
const {ethers} = require("hardhat")

describe("Payments", function() {
    let acc1
    let acc2
    let payments

    this.beforeEach(async function() {
        [acc1, acc2] = await ethers.getSigners()
        const Payments =  await ethers.getContractFactory("Payments", acc1)
        payments = await Payments.deploy()
    })

    it("should be deployed", async function() {
        expect(payments.target).to.be.properAddress
    })

    it("should have 0 ethers by default", async function() {
        const balance = await payments.currentBalance()
        expect(balance).to.eq(0)
    })

    it("it should be possible to send funds",async function() {
        const sum = 100
        const msg = "Hello from Hardhat"
        const tx = await payments.connect(acc2).pay(msg, {value: sum})
        await expect(() => tx).to.changeEtherBalance(acc2, -100)
        await expect(() => tx).to.changeEtherBalances([acc2, payments], [-sum, sum])
        await tx.wait()
        const balance = await payments.currentBalance()
        expect(balance).to.eq(100)

        const newPayment = await payments.getPayment(acc2,0)
        expect(newPayment.message).to.eq(msg)
        expect(newPayment.amount).to.eq(sum)
        expect(newPayment.from).to.eq(acc2.address)
    })
})