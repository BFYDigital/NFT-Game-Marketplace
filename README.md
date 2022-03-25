# ERC721 Zombie Game Marketplace

## Table of Contents

- [About](#about)
- [Prerequisite](#prerequisite)
- [Running](#running)
- [Deploying to a testnet](#deployment)
- [Screenshots](#screenshots)

## About <a name="about"></a>

This is the accompanying project to our [ERC721 Zombie Game](https://github.com/BFYDigital/erc721-zombie-game) built with [Vue.js](https://vuejs.org/) and the [Truffle Suite](https://trufflesuite.com/). This project allows users to trade their zombies in exchange for ETH. It leverages the features of the ERC721 standard to perform transfer.

## Prerequisite <a name="prerequisite"></a>

This project requires [ERC721 Zombie Game](https://github.com/BFYDigital/erc721-zombie-game) or any other ERC721 compliant token to be deployed. The contract address of the ERC721 token should be placed in the `client/.env` file.

## Running <a name="running"></a>

To run the application in a development enviroment:

- Copy the project using: `git clone https://github.com/BFYDigital/NFT-Game-Marketplace`
- Install package dependencies `npm install`
- modify the contents of `.env` and `client/.env`
- Run a local blockchain:

```bash
truffle develop
migrate
```

- Change into the client directory: `cd client`
- Install package dependencies `npm install`
- Start the project: `npm run dev`

## Deploying to a testnet <a name="deployment"></a>

This project uses infura. Modify the `networks` property in `truffle-config.js` to use other providers.

- Replace the `PRIVATE_KEY` property in `.env` with your wallet's backup phrase.
- Place you infura project key into the `INFURA_PROJECT_ID` property in `.env`.
- Replace `VITE_ZOMBIE_TOKEN_ADDESS` with your ERC721 token contract address in `client/.env`.
- Run truffle's migration command

```bash
truffle migrate --network <your target network>
```

## Screenshots <a name="screenshots"></a>

![zombie-marketplace-1](https://user-images.githubusercontent.com/98951489/160137547-1f929b1d-1628-4bb5-a5ed-45f7e1fa1c4f.png)
![zombie-marketplace-2](https://user-images.githubusercontent.com/98951489/160137648-d4da9cd5-d125-4050-8019-70755ec7d125.png)
![zombie-marketplace-3](https://user-images.githubusercontent.com/98951489/160137729-2d3fe2a8-147b-491c-ac98-53ab0ec549d4.png)
![zombie-marketplace-4](https://user-images.githubusercontent.com/98951489/160137816-7bebfdf3-ee2b-46ab-a1b4-c754feceb138.png)
![zombie-marketplace-5](https://user-images.githubusercontent.com/98951489/160137881-74f2f16d-9170-4b4f-b7bf-6a257b777e14.png)
