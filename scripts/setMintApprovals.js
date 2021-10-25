async function main() {
  const whitelist = ["0x4Dd958cA0455BFb231770cD06898894b4c974671"]
  const contract = await ethers.getContractAt(
    "Invite1155",
    process.env.TESTNET_CONTRACT_ADDRESS,
    await ethers.getSigner()
  )
  const result = await contract.setMintApprovals(whitelist, [true], 5)
  console.log("Tx: ", result.hash)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
