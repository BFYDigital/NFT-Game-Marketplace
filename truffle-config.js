const path = require("path");

const HDWalletProvider = require('@truffle/hdwallet-provider');

require('dotenv').config();

module.exports = {
  networks: {
    develop: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    rinkeby: {
      provider: () => new HDWalletProvider(process.env.PRIVATE_KEY, `wss://rinkeby.infura.io/ws/v3/${process.env.INFURA_PROJECT_ID}`),
      network_id: 4,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    }
  },
  compilers: {
    solc: {
      version: "0.8.11"
    }
  },
  contracts_build_directory: path.join(__dirname, "client/src/contracts")
};
