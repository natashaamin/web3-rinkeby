
// vscode will auto-import ethers as long as we install the extensions

const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1")
    });
    await waveContract.deployed();

    /* Get contract address */
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);

    console.log("Contract Balance", hre.ethers.utils.formatEther(contractBalance));

    console.log("Contract deployed by:", owner.address);

    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    // I wave myself
    // let waveTxn = await waveContract.wave();
    // await waveTxn.wait();

    // waveCount = await waveContract.getTotalWaves();

    // // random person who wave
    // waveTxn = await waveContract.connect(randomPerson).wave();
    // await waveTxn.wait()

    // waveCount = await waveContract.getTotalWaves();

    /* Let's try two waves now */
    const waveTxn = await waveContract.wave("0x94806e9B50075b9c87F24A71138DC097C83dE6cE", 1, "This is wave #1", "test");
    await waveTxn.wait();
    
    
    /* Get contract balance and see what happened! */
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain();