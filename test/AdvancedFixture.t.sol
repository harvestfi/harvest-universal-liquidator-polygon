// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../src/core/UniversalLiquidator.sol";
import "../src/core/UniversalLiquidatorRegistry.sol";

import "../src/core/dexes/UniV3Dex.sol";
import "../src/core/dexes/BalancerDex.sol";
import "../src/core/dexes/SushiswapDex.sol";
import "../src/core/dexes/CurveDex.sol";

abstract contract AdvancedFixture is Test {
    UniversalLiquidator internal universalLiquidator;
    UniversalLiquidatorRegistry internal universalLiquidatorRegistry;

    UniV3Dex internal uniV3Dex;
    BalancerDex internal balancerDex;
    SushiswapDex internal sushiswapDex;
    CurveDex internal curveDex;

    address[] internal intermediateTokens = [
        0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619, // WETH
        0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270, // WMATIC
        0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174, // USDC
        0xc2132D05D31c914a87C6611C10748AEb04B58e8F // USDT
    ];

    constructor() {}

    function setupDexes() internal {}
}
