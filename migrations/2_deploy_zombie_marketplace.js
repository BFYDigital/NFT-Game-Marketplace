const FeedingZombie = artifacts.require("FeedingZombie");
const ZombieMarketplace = artifacts.require("ZombieMarketplace");

require('dotenv').config({ path: '../client/.env.local' });
require('dotenv').config({ path: '../client/.env' });

module.exports = async function (deployer) {
  let address = process.env.VITE_ZOMBIE_TOKEN_ADDESS;
  deployer.deploy(ZombieMarketplace, address);
};
