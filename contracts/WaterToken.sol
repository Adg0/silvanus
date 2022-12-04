// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WaterToken is ERC20, Ownable {
    address private silvanus;

    constructor() ERC20("Water", "H2O") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
        // set rain permission to silvanus contract
    }

    function rain(uint256 _volume) public {
        require(msg.sender == silvanus, "Only silvanus contract can start Rain!");
        _mint(msg.sender, _volume * 10 ** decimals());
    }

    function setSilvanus(address _newAddress) public onlyOwner {
        silvanus = _newAddress;
    }
}