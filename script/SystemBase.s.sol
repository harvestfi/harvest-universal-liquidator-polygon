// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "openzeppelin/utils/Strings.sol";

import "../src/core/UniversalLiquidator.sol";
import "../src/core/UniversalLiquidatorRegistry.sol";

contract SystemBaseScript is Script {
    using stdJson for string;
    using Strings for uint256;

    UniversalLiquidatorRegistry public universalLiquidatorRegistry;
    UniversalLiquidator public universalLiquidator;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        postDeploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        universalLiquidatorRegistry = new UniversalLiquidatorRegistry();
        universalLiquidator = new UniversalLiquidator();
        universalLiquidator.setPathRegistry(address(universalLiquidatorRegistry));

        console.log("Universal Liquidator: ", address(universalLiquidator));
        console.log("Universal Liquidator Registry: ", address(universalLiquidatorRegistry));
    }

    /**
     * @notice Check if the key exist in deployed-addresses.json file
     */
    function preDeploy() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/deployed-addresses.json");
        string memory json = vm.readFile(path);

        json.readString(string.concat(string.concat(".", vm.envString("NETWORK")), ".UniversalLiquidator"));
        json.readString(string.concat(string.concat(".", vm.envString("NETWORK")), ".UniversalLiquidatorRegistry"));
    }

    /**
     * @notice Write the deployed addresses to the deployed-addresses.json file
     */
    function postDeploy() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/deployed-addresses.json");

        string memory key = string.concat(string.concat(".", vm.envString("NETWORK")), ".UniversalLiquidator");
        string memory value = uint256(uint160(address(universalLiquidator))).toHexString(20);
        value.write(path, key);

        key = string.concat(string.concat(".", vm.envString("NETWORK")), ".UniversalLiquidatorRegistry");
        value = uint256(uint160(address(universalLiquidatorRegistry))).toHexString(20);
        value.write(path, key);
    }
}
