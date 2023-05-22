// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract MultiSwapPaths {
    uint256 internal _tokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _tokenPairs;

    constructor() {}
}
