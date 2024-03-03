import { ethers } from "hardhat";

async function main() {
 

  const nftmarketpace = await ethers.deployContract("NFTMarketplace");

  await nftmarketpace.waitForDeployment();

  console.log(
    `NFTMarketplace contract with deployed to ${nftmarketpace.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
