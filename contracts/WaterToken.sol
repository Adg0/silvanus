// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract WaterToken is ERC20, Ownable, AccessControl {
    address private silvanus;
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("Water", "H2O") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 _volume) public onlyRole(MINTER_ROLE) {
        //require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, _volume);
    }

    function setSilvanus(address _newAddress) public onlyOwner {
		_revokeRole(MINTER_ROLE, silvanus);
        silvanus = _newAddress;
		_grantRole(MINTER_ROLE, silvanus);
    }
}