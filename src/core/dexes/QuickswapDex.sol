// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// imported contracts and libraries
import "./UniBasedDex.sol";

// libraries
import "../../libraries/Addresses.sol";

contract QuickswapDex is UniBasedDex(Addresses.quickSwapRouter) {}
