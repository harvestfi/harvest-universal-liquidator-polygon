// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

library Types {
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
        address intermediateToken;
        address whale;
        DexSetting[] dexSetup;
    }
}
