// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

abstract contract EnvVariables is Test {
    // Defaults to a public endpoint so the suite needs no secret. Set RPC_URL to
    // point it at your own provider.
    string internal _POLYGON_RPC_URL = vm.envOr("RPC_URL", string("https://polygon.drpc.org"));
    address internal _governance = 0xF066789028fE31D4f53B69B81b328B8218Cc0641;
}
