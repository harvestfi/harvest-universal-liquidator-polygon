// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";

import "../src/core/UniversalLiquidator.sol";
import "../src/core/UniversalLiquidatorRegistry.sol";

contract SystemBaseScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        deploy();
        //vm.stopBroadcast();
    }

    function deploy() public {
        UniversalLiquidatorRegistry universalLiquidatorRegistry = new UniversalLiquidatorRegistry();
        UniversalLiquidator universalLiquidator = new UniversalLiquidator();
        universalLiquidator.setPathRegistry(address(universalLiquidatorRegistry));

        console.log("Universal Liquidator: ", address(universalLiquidator));
        console.log("Universal Liquidator Registry: ", address(universalLiquidatorRegistry));
    }
}
