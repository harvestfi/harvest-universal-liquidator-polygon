// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract Pools {
    uint256 internal _poolPairsCount;
    mapping(uint256 => Types.PoolPair) internal _pools;

    constructor() {
        bytes32[] memory _curPool = new bytes32[](2);

        // Pool0 - WMATIC -> stMATIC
        _curPool[0] = 0x8159462d255c1d24915cb51ec361f700174cd99400000000000000000000075d;

        Types.PoolPair storage newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
        newPool.buyToken = 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4;
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        _curPool = new bytes32[](2);

        // Pool1 - USDC -> DAI
        _curPool[0] = bytes20(0x445FE580eF8d70FF569aB36e80c647af338db351);

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        newPool.buyToken = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
        newPool.dexName = "curve";
        newPool.pools = _curPool;

        // Pool2 - GHST -> USDC -> BAL
        _curPool[0] = 0xae8f935830f6b418804836eacb0243447b6d977c000200000000000000000ad1;
        _curPool[1] = 0x0297e37f1873d2dab4487aa67cd56b58e2f27875000100000000000000000002;

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7;
        newPool.buyToken = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        // Pool3 - axlUSDC -> USDC
        _curPool[0] = bytes20(0xfBA3b7Bb043415035220b1c44FB4756434639392);

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x750e4C4984a9e0f12978eA6742Bc1c5D248f40ed;
        newPool.buyToken = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        newPool.dexName = "curve";
        newPool.pools = _curPool;

        // Pool4 - USDC -> USDT
        _curPool[0] = bytes20(0x445FE580eF8d70FF569aB36e80c647af338db351);

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        newPool.buyToken = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
        newPool.dexName = "curve";
        newPool.pools = _curPool;

        // Pool5 - USDC -> BAL
        _curPool[0] = 0x0297e37f1873d2dab4487aa67cd56b58e2f27875000100000000000000000002;

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        newPool.buyToken = 0x9a71012B13CA4d3D0Cdc72A177DF3ef03b0E76A3;
        newPool.dexName = "balancer";
        newPool.pools = _curPool;
    }
}
