# Silvanus NFT gaming

**NOTE**: This is a proof of concept, not be used in production environment.

## Summary

Silvanus is an NFT gaming completely decentralized and on chain.

Players water the seedling NFTs to grow them into a tree.

Players race to grow their seedling before the tree NFT dies when wild fire or flood happens.

The core feature of the game is to promote forestation and pioneer smt...

The goal is, by harnessing the power of free markets to aggregate collective knowledge and provide the general public with an unbiased source of truth in regards to the likelihood of certain significant events happening in the future.

[img](https://imgur.com/QJ4Rtv4.png)

[![Silvanus](https://imgur.com/0h5eKZs.png)](https://youtu.be/video "Silvanus")

[Project Slides Deck](https://docs.google.com/presentation/d/...)

We wrote contract for dynamic NFT with the help of openzepplen and NiftyKit.

The front end application is written with vite and generated from unity.
The repository for the Front-End is avalaible here: https://github.com/...

## Overview



## Requirements

1. [NiftKit account](https://app.niftykit.com/) and [Hashlips](https://github.com/HashLips/hashlips_art_engine_app/releases/tag/v0.1.0_alpha)
2. [Alchemy provider api](https://www.alchemy.com/) or another provider

# Optimism Smart Contract

Contracts are extended openzepplen contracts. The game logic consists of two NFTs and an ERC20 token.

The `silvanus NFT` is responsible for processing all growth event. The program is responsible for implementing all the logic for the game.

The `potion NFT` is used to revive dead trees, any account that holds silvanusTree NFT gets exponential potions minted during mint call to `potion contract`.

In `WaterToken.sol` we keep the logic of `Rain`, `MagicPotion.sol` contains approval to apply potion and `SilvanusTree.sol` keeps track of tree growth variable and triggers game master events.

## Useful Resources

[Testnet Dispensary](https://goerlifaucet.com/)

[Optimism Bridge](https://app.optimism.io/bridge/deposit)

[Etherscan](https://goerli-optimism.etherscan.io/)

[Remix IDE](https://remix.ethereum.org/)

[NiftyKit-Hashlips: The best no code solution for NFTs](https://niftykit.com/hashlips-niftykit-the-best-no-code-solution-for-nfts/)

[Optimism getting started](https://community.optimism.io/docs/guides/)

[Remix: Quick start into web3](https://remix-ide.readthedocs.io/en/latest/index.html)

[Openzepplin: ERC standards and library](https://docs.openzeppelin.com/contracts/4.x/)

[Deploying on optimism with Hardhat](https://community.optimism.io/docs/developers/build/using-tools/#hardhat)

[Hardhat: Quick start](https://hardhat.org/hardhat-runner/docs/getting-started#quick-start)

[Metamask: Integrating web3 into dapp](https://docs.metamask.io/guide/)
