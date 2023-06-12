// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract MultiSwapPaths {
    uint256 internal _multiTokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _multiTokenPairs;

    constructor() {
        address[] memory _path = new address[](3);

        // Pair0 - WMAITC -> USDC -> AAVE
        _path[0] = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        _path[1] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _path[2] = 0xD6DF932A45C0f255f85145f286eA0b292B21C90B;

        Types.TokenPair storage newTokenPair = _multiTokenPairs[_multiTokenPairCount++];
        newTokenPair.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newTokenPair.buyToken = 0xD6DF932A45C0f255f85145f286eA0b292B21C90B;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x21Cb017B40abE17B6DFb9Ba64A3Ab0f24A7e60EA;
        newTokenPair.dexSetup.push(Types.DexSetting("UniV3Dex", _path));

        // Pair1 - GHST -> USDC -> BAL
        _path[0] = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7;
        _path[1] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _path[2] = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;

        newTokenPair = _multiTokenPairs[_multiTokenPairCount++];
        newTokenPair.sellToken = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7;
        newTokenPair.buyToken = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xDE5D496dD39663F604bBDd7F5C146dBA77e68Dde;
        newTokenPair.dexSetup.push(Types.DexSetting("BalancerDex", _path));

        // Pair2 - SUSHI -> WETH -> AAVE
        _path[0] = 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a;
        _path[1] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        _path[2] = 0xD6DF932A45C0f255f85145f286eA0b292B21C90B;

        newTokenPair = _multiTokenPairs[_multiTokenPairCount++];
        newTokenPair.sellToken = 0x0b3F868E0BE5597D5DB7fEB59E1CADBb0fdDa50a;
        newTokenPair.buyToken = 0xD6DF932A45C0f255f85145f286eA0b292B21C90B;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x75F101a581A6be2C65b060B2Ac88F88046c54852;
        newTokenPair.dexSetup.push(Types.DexSetting("SushiswapDex", _path));

        // Pair3 - axlUSDC -> USDC -> USDT
        _path[0] = 0x750e4C4984a9e0f12978eA6742Bc1c5D248f40ed;
        _path[1] = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        _path[2] = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

        newTokenPair = _multiTokenPairs[_multiTokenPairCount++];
        newTokenPair.sellToken = 0x750e4C4984a9e0f12978eA6742Bc1c5D248f40ed;
        newTokenPair.buyToken = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xE743a49F04F2f77eB2D3b753aE3AD599dE8CEA84;
        newTokenPair.dexSetup.push(Types.DexSetting("CurveDex", _path));
    }
}
