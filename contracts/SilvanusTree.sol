// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WaterToken.sol";

contract SilvanusTree is ERC721URIStorage, Ownable {
    constructor(string memory _name, string memory _symbol, address _tokenContract, string memory _image) 
        ERC721(_name, _symbol) {
            _H2Otoken = _tokenContract;
            _imageURL = _image;
        }

    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private _H2Otoken;
    string private _imageURL; // https://ipfs.io/ipfs/QmekwVVTw3rUAS97QoeLpB7KHD8xVrnCD9bv8Jqb3GypJq/1_1.json

    uint256 fee = 0 ether;

    struct Tree {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
        bool life;
    }

    Tree[] public trees;
    
    event NewTree(address indexed owner, uint256 id, uint256 dna);

    // Helpers
    function _createRandomNum(uint256 _mod) internal view returns (uint256) {
        uint256 randomNum = uint256(
        keccak256(abi.encodePacked(block.timestamp, msg.sender))
        );
        return randomNum % _mod;
    }

    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    function withdraw() external payable onlyOwner {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    // Creation
    function _createTree(string memory _name) internal {
        uint256 newItemId = _tokenIds.current();
        uint8 randRarity = uint8(_createRandomNum(100));
        uint256 randDna = _createRandomNum(10**16);
        Tree memory newTree = Tree(_name,newItemId,randDna,1,randRarity,true);
        trees.push(newTree);
        _safeMint(msg.sender, newItemId);
        bytes memory _uri = bytes(_imageURL);
        uint8 _image = randRarity % 6;
        if(_image == 0) {
            _image++;
        }
        bytes memory _imageId = bytes(Strings.toString(_image));
        _uri[_uri.length - 8] = _imageId[0];
        _setTokenURI(newItemId, string(_uri));
        emit NewTree(msg.sender, newItemId, randDna);
        _tokenIds.increment();
    }

    function createRandomTree(string memory _name) public payable {
        require(msg.value >= fee);
        _createTree(_name);
    }

    // Getter
    function getTrees() public view returns(Tree[] memory) {
        return trees;
    }

    function getOwnerTrees(address _owner) public view returns (Tree[] memory) {
        Tree[] memory result = new Tree[](balanceOf(_owner));
        uint256 counter = 0;
        for (uint256 i = 0; i < trees.length; i++) {
            if (ownerOf(i) == _owner) {
                result[counter] = trees[i];
                counter++;
            }
        }
        return result;
    }

    event WildFire(uint256 affectedToken, uint256 damage);
    event Flood(uint256 affectedToken, uint256 damage);
    event WaterTree(address from, uint256 tokenId);
    event Rain(uint256 volume);

    function startWildFire(uint256 _tokenId, uint256 _damage) public onlyOwner {
        for (uint256 i = _tokenId; i > 0; i--){
           uint256 _allowance = IERC20(_H2Otoken).allowance(ownerOf(i),address(this));
           uint256 _balance = IERC20(_H2Otoken).balanceOf(ownerOf(i));
           uint256 _volume = (_allowance <= _balance) ? _allowance : _balance;
           uint256 _withdraw = 0;
           bool safe = true;
           if(_volume >= _damage){
               _withdraw = _damage;
           } else {
               _withdraw = _volume;
                safe = false;
           }
            IERC20(_H2Otoken).safeTransferFrom(ownerOf(i),address(this),_withdraw);
            _updateTree(i,safe);
        }
        // emit
        emit WildFire(_tokenId,_damage);
    }

    function waterTree(uint256 _tokenId,uint256 _volume) public {
        IERC20(_H2Otoken).safeTransferFrom(msg.sender,address(this),_volume);
        _updateTree(_tokenId,true);
        // emit watering event
        emit WaterTree(msg.sender, _tokenId);
    }

    function startRain(uint256 _volume) public onlyOwner {
        _rain(_volume);
        // emit rain event 
        emit Rain(_volume);     
    }

    function _updateTree(uint256 _tokenId, bool _increase) internal{
        Tree storage tree = trees[_tokenId];
        if(_increase){
            // Increase
            tree.level++;
        } else {
            // Decrease
            if(tree.level > 0){
                tree.level--;
            } else {
                // tree is dead
                tree.life = false;
            }
        }
        _updateImage(_tokenId, tree.level, tree.life);
    }

    function _updateImage(uint256 _tokenId, uint256 _level, bool _life) internal {
        bytes memory _uri = bytes(tokenURI(_tokenId));
        bytes memory _newLevel = bytes(Strings.toString(_level + 1));
        
        if(_life && _level < 3){
            _uri[_uri.length - 6] = _newLevel[0];
        } else if(_level >= 3) {
          _uri[_uri.length - 6] = "3";  
        } else {
            _uri[_uri.length - 6] = "x";
        }
        _setTokenURI(_tokenId, string(_uri));
    }

    function _rain(uint256 _volume) internal{
        uint256 tokens = _tokenIds.current();
        WaterToken(_H2Otoken).rain(_volume*tokens);
        bool flooding = false;
        uint256 flood = _createRandomNum(tokens);
        for (uint256 i = 0; i < tokens; i++){
           IERC20(_H2Otoken).safeTransfer(ownerOf(i),_volume);
           // Update level for all trees
           if(i >= flood) {
               flooding = true;
               emit Flood(i,_volume);
           }
           _updateTree(i,!flooding);
        }
    }

    function updateH2Oaddress(address _newAddress) public onlyOwner {
        _H2Otoken = _newAddress;
    }

    function applyPotion(uint256 _tokenId, uint256 _usePower) public {
        Tree storage tree = trees[_tokenId];
        tree.level += uint8(_usePower*2);
        tree.life = true;
        _updateImage(_tokenId, tree.level, tree.life);
    }
}
