// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract MultiSwapPaths {
    uint256 internal _multiTokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _multiTokenPairs;

    constructor() {}
}
