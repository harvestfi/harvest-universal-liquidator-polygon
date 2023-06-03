// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract CrossDexSwapPaths {
    uint256 internal _crossDexTokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _crossDexTokenPairs;

    constructor() {
        address[] memory _pathA = new address[](2);
        address[] memory _pathB = new address[](2);

        // Pair0 - (UniV3) WMAITC -> USDC -> BAL (Balancer)
        _pathA[0] = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        _pathA[1] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathB[0] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathB[1] = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;

        Types.TokenPair storage newTokenPair = _crossDexTokenPairs[_crossDexTokenPairCount++];
        newTokenPair.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newTokenPair.buyToken = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x21Cb017B40abE17B6DFb9Ba64A3Ab0f24A7e60EA;
        newTokenPair.dexSetup.push(Types.DexSetting("uniV3", _pathA));
        newTokenPair.dexSetup.push(Types.DexSetting("balancer", _pathB));

        // Pair1 - (UniV3) WMATIC -> WETH -> AAVE (Sushi)
        _pathA[0] = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7;
        _pathA[1] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        _pathB[0] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        _pathB[1] = 0xD6DF932A45C0f255f85145f286eA0b292B21C90B;

        newTokenPair = _crossDexTokenPairs[_crossDexTokenPairCount++];
        newTokenPair.sellToken = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7;
        newTokenPair.buyToken = 0xD6DF932A45C0f255f85145f286eA0b292B21C90B;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x21Cb017B40abE17B6DFb9Ba64A3Ab0f24A7e60EA;
        newTokenPair.dexSetup.push(Types.DexSetting("uniV3", _pathA));
        newTokenPair.dexSetup.push(Types.DexSetting("sushi", _pathB));

        // Pair2 - (UniV3) UNI -> USDC -> USDT (Curve)
        _pathA[0] = 0xb33EaAd8d922B1083446DC23f610c2567fB5180f;
        _pathA[1] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathB[0] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathB[1] = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

        newTokenPair = _crossDexTokenPairs[_crossDexTokenPairCount++];
        newTokenPair.sellToken = 0xb33EaAd8d922B1083446DC23f610c2567fB5180f;
        newTokenPair.buyToken = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x06959153B974D0D5fDfd87D561db6d8d4FA0bb0B;
        newTokenPair.dexSetup.push(Types.DexSetting("uniV3", _pathA));
        newTokenPair.dexSetup.push(Types.DexSetting("curve", _pathB));
    }
}
