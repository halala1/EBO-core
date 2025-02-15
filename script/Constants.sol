// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

// Arbitrum One
address constant _ARBITRUM_MAINNET_GRAPH_TOKEN = 0x9623063377AD1B27544C965cCd7342f7EA7e88C7;
address constant _ARBITRUM_MAINNET_HORIZON_STAKING = address(0x0);
address constant _ARBITRUM_MAINNET_EPOCH_MANAGER = 0x5A843145c43d328B9bB7a4401d94918f131bB281;
address constant _ARBITRUM_MAINNET_GOVERNOR = address(0x0);
address constant _ARBITRUM_MAINNET_ARBITRATOR = address(0x100);
address constant _ARBITRUM_MAINNET_COUNCIL = address(0x101);

// Arbitrum Sepolia
address constant _ARBITRUM_SEPOLIA_GRAPH_TOKEN = 0x1A1af8B44fD59dd2bbEb456D1b7604c7bd340702;
address constant _ARBITRUM_SEPOLIA_HORIZON_STAKING = 0x3F53F9f9a5d7F36dCC869f8D2F227499c411c0cf;
address constant _ARBITRUM_SEPOLIA_EPOCH_MANAGER = 0x7975475801BEf845f10Ce7784DC69aB1e0344f11;
address constant _ARBITRUM_SEPOLIA_GOVERNOR = 0xadE6B8EB69a49B56929C1d4F4b428d791861dB6f;
address constant _ARBITRUM_SEPOLIA_ARBITRATOR = address(0x100);
address constant _ARBITRUM_SEPOLIA_COUNCIL = address(0x101);

// Data
uint64 constant _MIN_THAWING_PERIOD = 3 days;
uint128 constant _MAX_USERS_TO_CHECK = 10;
