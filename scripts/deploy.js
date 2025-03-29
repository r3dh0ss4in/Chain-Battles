async function main() {
    console.log("Starting deployment...");
    
    // Get signer
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
  
    // Get contract factory
    const ChainBattles = await ethers.getContractFactory("ChainBattles");
    console.log("Contract factory loaded");
  
    // Deploy contract
    console.log("Deploying contract...");
    const chainBattles = await ChainBattles.deploy();
    
    // Wait for deployment
    await chainBattles.waitForDeployment();
    console.log("Waiting for deployment confirmation...");
  
    // Get address
    const address = await chainBattles.getAddress();
    console.log("ChainBattles deployed to:", address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error("Deployment failed:", error);
      process.exit(1);
    });