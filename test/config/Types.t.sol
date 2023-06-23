// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

abstract contract Types {
    struct Dex {
        address addr;
        bytes32 id;
    }

    struct DexSetting {
        string dexName;
        address[] paths;
    }

    struct TokenPair {
        address sellToken;
        address buyToken;
        address whale;
        DexSetting[] dexSetup;
    }

    struct PoolPair {
        address sellToken;
        address buyToken;
        string dexName;
        bytes32[] pools;
    }

    struct FeePair {
        address sellToken;
        address buyToken;
        string dexName;
        uint256 fee;
    }
}
