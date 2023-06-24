// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract Fees {
    uint256 internal _feePairsCount;
    mapping(uint256 => Types.FeePair) internal _fees;

    constructor() {
        // Pool0 - DAI -> USDC
        Types.FeePair storage newFee = _fees[_feePairsCount++];
        newFee.sellToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        newFee.buyToken = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;
        newFee.dexName = "UniV3Dex";
        newFee.fee = 500;

        // Pool1 - WMATIC -> USDC
        newFee = _fees[_feePairsCount++];
        newFee.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newFee.buyToken = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;
        newFee.dexName = "UniV3Dex";
        newFee.fee = 500;

        // Pool2 - WMATIC -> WETH
        newFee = _fees[_feePairsCount++];
        newFee.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newFee.buyToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        newFee.dexName = "UniV3Dex";
        newFee.fee = 500;
    }
}
