import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  // defaultNetwork: 'base',
  // networks: {
  //   base_sepolia: {
  //     url: 'https://sepolia.base.org',
  //     accounts: ['<private key 1>'],
  //   },
  //   sepolia: {
  //     url: 'https://sepolia.infura.io/v3/<key>',
  //     accounts: ['<private key 1>', '<private key 2>'],
  //   },
  // },
  solidity: {
    version: '0.8.30',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
};

export default config;
