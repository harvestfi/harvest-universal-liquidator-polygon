// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract CrossDexSwapPaths {
    uint256 internal _crossDexTokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _crossDexTokenPairs;

    constructor() {}
}
