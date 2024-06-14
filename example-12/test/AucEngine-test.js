const {expect} = require("chai")
const {ethers} = require("hardhat")

describe("AucEngine", function() {
    let owner
    let buyer
    let seller
    let auct

    this.beforeEach(async function() {
        [owner, seller, buyer] = await ethers.getSigners()
        const AucEngine =  await ethers.getContractFactory("AucEngine", owner)
        auct = await AucEngine.deploy()
    })

    it("sets owner", async function() {
        const currentOwner = await auct.owner()
        expect(currentOwner).to.eq(owner)
    })  

    async function getTimestamp(bn) {
        return (
            await ethers.provider.getBlock(bn)
        ).timestamp
    }
    
    describe("createAuction", function() {
        it("create auction correctly", async function() {
            const duration = 60
            const tx = await auct.createAuction(
                ethers.parseEther("0.0001"),
                3,
                "fake item",
                duration
            )

            const cAuction = await auct.auctions(0)
            // console.log(cAuction)
            expect(cAuction.item).to.eq("fake item")
            // console.log(tx)
            const ts = await getTimestamp(tx.blockNumber)
            expect(cAuction.endsAt).to.eq(ts+duration)
        })  
    })

    function delay(ms) {
        return new Promise(resolve => setTimeout(resolve,ms))
    }

    describe("buy", function() {
        it("allows to buy", async function() {
            const duration = 60
            const tx = await auct.connect(seller).createAuction(
                ethers.parseEther("0.0001"),
                3,
                "fake item",
                duration
            )
            this.timeout(5000)
            await delay(1000)

            const buyTx = await auct.connect(buyer).buy(0, {value: ethers.parseEther("0.0001")})
            const cAuction = await auct.auctions(0)
            const finalPrice = cAuction.finalPrice


            const tenPercent = BigInt(Math.floor(Number(finalPrice) * 10 / 100));
            const expectedChange = finalPrice - tenPercent;
            await expect(() => buyTx).to.changeEtherBalance(seller, expectedChange);
            await expect(buyTx).to.emit(auct, 'AuctionEnded').withArgs(0, finalPrice, buyer.address)
            await expect(auct.connect(buyer).buy(0, {value: ethers.parseEther("0.0001")})).to.be.revertedWith("stopped!")

        })  

    })


    
    describe("startingPrice more than require", function() {
        it("try to create aution with false values", async function() {
            const duration = 1000
            await expect(
                auct.connect(seller).createAuction(
                    ethers.parseEther("0.0001"),
                    1000000000000,
                    "fake item",
                    duration
                )
            ).to.be.revertedWith('incorecct starting price');
        }) 
    })

    describe("try to buy on stopped auction", function() {
        it("try to buy aution with false values", async function() {
            await auct.createAuction(
                ethers.parseEther("0.0001"),
                10,
                "fake item",
                0
            )
            await auct.stop(0)
            await expect(auct.getPriceFor(0)).to.be.revertedWith('stopped!')
        }) 
    })
})