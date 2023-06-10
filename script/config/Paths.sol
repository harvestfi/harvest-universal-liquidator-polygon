// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

struct DexSetting {
    string dexName;
    address[] paths;
}

struct TokenPair {
    address sellToken;
    address buyToken;
    address intermediateToken;
    address whale;
    DexSetting[] dexSetup;
}

abstract contract Paths {
    uint256 internal _tokenPairCount;
    mapping(uint256 => TokenPair) internal _tokenPairs;

    constructor() {
        address[] memory _pathA = new address[](2);
        address[] memory _pathB = new address[](2);

        // Pair0 - WETH -> BOB
        _pathA[0] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        _pathA[1] = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;

        TokenPair storage newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        newTokenPair.buyToken = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x62ac55b745F9B08F1a81DCbbE630277095Cf4Be1;
        newTokenPair.dexSetup.push(DexSetting("UniV3Dex", _pathA));

        // Pair1 - WMATIC -> stMATIC
        _pathA[0] = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        _pathA[1] = 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newTokenPair.buyToken = 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x6e7a5FAFcec6BB1e78bAE2A1F0B612012BF14827;
        newTokenPair.dexSetup.push(DexSetting("BalancerDex", _pathA));

        // Pair2 - WMATIC -> SUSHI
        _pathA[0] = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        _pathA[1] = 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newTokenPair.buyToken = 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x6e7a5FAFcec6BB1e78bAE2A1F0B612012BF14827;
        newTokenPair.dexSetup.push(DexSetting("SushiswapDex", _pathA));

        // Pair3 - USDC -> DAI
        _pathA[0] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathA[1] = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        newTokenPair.buyToken = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x72A53cDBBcc1b9efa39c834A540550e23463AAcB;
        newTokenPair.dexSetup.push(DexSetting("CurveDex", _pathA));

        // Pair4 - (UniV3) UNI -> USDC -> USDT (Curve)
        _pathA[0] = 0xb33EaAd8d922B1083446DC23f610c2567fB5180f;
        _pathA[1] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathB[0] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _pathB[1] = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0xb33EaAd8d922B1083446DC23f610c2567fB5180f;
        newTokenPair.buyToken = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x06959153B974D0D5fDfd87D561db6d8d4FA0bb0B;
        newTokenPair.dexSetup.push(DexSetting("UniV3Dex", _pathA));
        newTokenPair.dexSetup.push(DexSetting("CurveDex", _pathB));
    }
}
