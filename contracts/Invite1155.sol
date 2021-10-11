// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC1155.sol";
import "./Whitelistable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Timers.sol";

contract Invite1155 is ERC1155, Ownable, Whitelistable {
    constructor(string memory baseTokenURI) ERC1155(baseTokenURI) {}

    mapping(uint256 => mapping(address => uint256)) private _mintApprovals;

    bool private canMint;

    function setCanMint(bool _canMint) public onlyOwner {
        canMint = _canMint;
    }

    function mintToMany(
        address[] calldata _to,
        uint256[] calldata _quantities,
        uint256 _id
    ) external onlyOwner {
        for (uint256 i = 0; i < _to.length; ++i) {
            address to = _to[i];
            uint256 quantity = _quantities[i];
            _mint(to, _id, quantity, "");
        }
    }

    function mint(
        address to,
        uint256 amount,
        uint256 id
    ) external {
        require(canMint, "Minting is disabled");
        require(
            _mintApprovals[id][_msgSender()] >= amount ||
                isWhitelisted(_msgSender()),
            "Invite: not approved to mint"
        );
        _mint(to, id, amount, bytes(""));
    }

    function setMintApproval(
        address spender,
        uint256 amount,
        uint256 id
    ) external onlyOwner {
        _mintApprovals[id][spender] = amount;
    }

    function setMintApprovals(
        address[] calldata spender,
        uint256[] calldata amounts,
        uint256 id
    ) external onlyOwner {
        require(
            spender.length == amounts.length,
            "Invite: spender and amounts arrays must be the same length"
        );
        for (uint256 i = 0; i < spender.length; ++i) {
            _mintApprovals[id][spender[i]] = amounts[i];
        }
    }

    function getMintApproval(address spender, uint256 id)
        external
        view
        returns (uint256)
    {
        return _mintApprovals[id][spender];
    }

    function setWhitelistCheck(
        string memory specification,
        address tokenAddress
    ) public virtual override onlyOwner {
        super.setWhitelistCheck(specification, tokenAddress);
    }
}
