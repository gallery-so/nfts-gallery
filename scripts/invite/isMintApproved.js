async function main() {
  const contract = await ethers.getContractAt(
    "Invite1155",
    process.env.CONTRACT_ADDRESS,
    await ethers.getSigner()
  )
  const result = await contract.isMintApproved("", 5)
  console.log(result)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
