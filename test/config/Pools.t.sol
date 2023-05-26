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
    }
}
