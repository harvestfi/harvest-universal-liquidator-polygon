// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

abstract contract EnvVariables is Test {
    string internal _POLYGON_RPC_URL = string.concat("https://polygon-mainnet.g.alchemy.com/v2/", vm.envString("ALCHEMEY_KEY"));
    address internal _governance = 0xF066789028fE31D4f53B69B81b328B8218Cc0641;
}
