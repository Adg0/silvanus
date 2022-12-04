// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SilvanusTree.sol";

contract MaigcPotion is ERC721Enumerable, Ownable {
    string fullPotionURI;
    string public emptyPotionURI;
    address public treeNFTAddress;
    bool public paused = false;

    struct Potion {
        uint256 power;
    }

    mapping(uint256 => Potion) public potions;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initFullPotionURI,
        string memory _initEmptyPotionURI,
        address _initTreeNFTAddress
        ) ERC721(_name, _symbol) {
            setFullPotionURI(_initFullPotionURI);
            setEmptyPotionURI(_initEmptyPotionURI);
            setTreeNFTAddress(_initTreeNFTAddress);
        }

    function mint() public{
        require(!paused, "Contract is paused.");
        IERC721 token = IERC721(treeNFTAddress);
        uint256 ownedAmount = token.balanceOf(msg.sender);
        // do something with owned amount
        uint256 supply = totalSupply();
        require(supply + 1 <= 5000, "Max supply of magic potions reached.");
        Potion memory newPotion = Potion(2 ** ownedAmount);
        potions[supply + 1] = newPotion;
        _safeMint(msg.sender, supply + 1);
    }

    function walletOfOwner(address _owner) public view returns (uint256[] memory){
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for(uint256 i; i < ownerTokenCount; i++){
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        Potion memory currentPotion = potions[_tokenId];
        if(currentPotion.power > 0){
            return _baseURI();
        }
        else {
            return emptyPotionURI;
        }
    }

    function applyPower(uint256 _tokenId, uint256 _usePower, uint256 _treeNFT) public {
        require(msg.sender == ownerOf(_tokenId), "You are not the owner of this NFT.");
        Potion storage currentPotion = potions[_tokenId];
        require(currentPotion.power >= _usePower, "Not enough power in potion.");
        currentPotion.power -= _usePower;
        SilvanusTree(treeNFTAddress).applyPotion(_treeNFT, _usePower);
    }

    function _baseURI() internal view virtual override returns (string memory){
        return fullPotionURI;
    }

    function setTreeNFTAddress(address _newAddress) public onlyOwner {
        treeNFTAddress = _newAddress;
    }

    function setFullPotionURI(string memory _newFullPotionURI) public onlyOwner {
        fullPotionURI = _newFullPotionURI;
    }

    function setEmptyPotionURI(string memory _newEmptyPotionURI) public onlyOwner {
        emptyPotionURI = _newEmptyPotionURI;
    }

    function pause(bool _state) public onlyOwner{
        paused = _state;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

}
