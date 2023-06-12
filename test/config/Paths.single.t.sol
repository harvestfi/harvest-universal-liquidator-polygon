// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract SingleSwapPaths {
    uint256 internal _singleTokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _singleTokenPairs;

    constructor() {
        address[] memory _path = new address[](2);

        // Pair0 - WETH -> BOB
        _path[0] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        _path[1] = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;

        Types.TokenPair storage newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        newTokenPair.buyToken = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x62ac55b745F9B08F1a81DCbbE630277095Cf4Be1;
        newTokenPair.dexSetup.push(Types.DexSetting("UniV3Dex", _path));

        // Pair1 - WMATIC -> stMATIC
        _path[0] = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        _path[1] = 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4;

        newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newTokenPair.buyToken = 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x6e7a5FAFcec6BB1e78bAE2A1F0B612012BF14827;
        newTokenPair.dexSetup.push(Types.DexSetting("BalancerDex", _path));

        // Pair2 - WMATIC -> SUSHI
        _path[0] = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        _path[1] = 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a;

        newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newTokenPair.buyToken = 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x6e7a5FAFcec6BB1e78bAE2A1F0B612012BF14827;
        newTokenPair.dexSetup.push(Types.DexSetting("SushiswapDex", _path));

        // Pair3 - USDC -> DAI
        _path[0] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _path[1] = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

        newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        newTokenPair.buyToken = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x72A53cDBBcc1b9efa39c834A540550e23463AAcB;
        newTokenPair.dexSetup.push(Types.DexSetting("CurveDex", _path));
    }
}
