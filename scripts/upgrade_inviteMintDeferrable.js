const { ethers, upgrades } = require("hardhat")

async function main() {
  const ContractV2 = await ethers.getContractFactory("InviteV2")
  console.log("Upgrading Contract...")
  const box = await upgrades.upgradeProxy("address to proxy", ContractV2)
  console.log("Collectible upgraded")
}

main()
