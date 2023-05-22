// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract Pools {
    uint256 internal _poolPairsCount;
    mapping(uint256 => Types.PoolPair) internal _pools;

    constructor() {
        bytes32[] memory _curPool = new bytes32[](2);
        _curPool[0] = 0xcc65a812ce382ab909a11e434dbf75b34f1cc59d000200000000000000000001;
        _curPool[1] = 0xc764b55852f8849ae69923e45ce077a576bf9a8d0002000000000000000003d7;

        Types.PoolPair storage newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x040d1EdC9569d4Bab2D15287Dc5A4F10F56a56B8; // BAL
        newPool.buyToken = 0x912CE59144191C1204E64559FE8253a0e49E6548; // ARB
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        _curPool = new bytes32[](1);
        _curPool[0] = 0x36bf227d6bac96e2ab1ebb5492ecec69c691943f000200000000000000000316;

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x5979D7b546E38E414F7E9822514be443A4800529; // wstETH
        newPool.buyToken = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        _curPool[0] = 0x178e029173417b1f9c8bc16dcec6f697bc323746000200000000000000000158;

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x5979D7b546E38E414F7E9822514be443A4800529; // wstETH
        newPool.buyToken = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // USDC
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        _curPool = new bytes32[](2);
        _curPool[0] = 0x36bf227d6bac96e2ab1ebb5492ecec69c691943f000200000000000000000316;
        _curPool[1] = 0xc764b55852f8849ae69923e45ce077a576bf9a8d0002000000000000000003d7;

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x5979D7b546E38E414F7E9822514be443A4800529; // wstETH
        newPool.buyToken = 0x912CE59144191C1204E64559FE8253a0e49E6548; // ARB
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        _curPool = new bytes32[](1);
        _curPool[0] = 0xcc65a812ce382ab909a11e434dbf75b34f1cc59d000200000000000000000001;

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH
        newPool.buyToken = 0x040d1EdC9569d4Bab2D15287Dc5A4F10F56a56B8; // BAL
        newPool.dexName = "balancer";
        newPool.pools = _curPool;

        _curPool[0] = bytes20(0x7f90122BF0700F9E7e1F688fe926940E8839F353);

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT
        newPool.buyToken = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // USDC
        newPool.dexName = "curve";
        newPool.pools = _curPool;

        _curPool[0] = bytes20(0xC9B8a3FDECB9D5b218d02555a8Baf332E5B740d5);

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // USDC
        newPool.buyToken = 0x17FC002b466eEc40DaE837Fc4bE5c67993ddBd6F; // FRAX
        newPool.dexName = "curve";
        newPool.pools = _curPool;

        _curPool[0] = bytes20(0x960ea3e3C7FB317332d990873d354E18d7645590);

        newPool = _pools[_poolPairsCount++];
        newPool.sellToken = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH
        newPool.buyToken = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT
        newPool.dexName = "curve";
        newPool.pools = _curPool;
    }
}
