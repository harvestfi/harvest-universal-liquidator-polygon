// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "openzeppelin/utils/Strings.sol";

import "../src/interfaces/IUniversalLiquidatorRegistry.sol";

import "../src/core/dexes/UniV3Dex.sol";
import "../src/core/dexes/BalancerDex.sol";
import "../src/core/dexes/SushiswapDex.sol";
import "../src/core/dexes/CurveDex.sol";
import "../src/core/dexes/QuickswapDex.sol";

contract DexScript is Script {
    using stdJson for string;
    using Strings for uint256;

    address _registry;
    address _newDex;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        postDeploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        if (keccak256(bytes(vm.envString("DEX"))) == keccak256(bytes("UniV3Dex"))) {
            UniV3Dex uniV3Dex = new UniV3Dex();
            console.log("UniV3Dex: ", address(uniV3Dex));
            IUniversalLiquidatorRegistry(_registry).addDex(keccak256(bytes(vm.envString("DEX_NAME"))), address(uniV3Dex));
            _newDex = address(uniV3Dex);
        } else if (keccak256(bytes(vm.envString("DEX"))) == keccak256(bytes("BalancerDex"))) {
            BalancerDex balancerDex = new BalancerDex();
            console.log("BalancerDex: ", address(balancerDex));
            IUniversalLiquidatorRegistry(_registry).addDex(keccak256(bytes(vm.envString("DEX_NAME"))), address(balancerDex));
            _newDex = address(balancerDex);
        } else if (keccak256(bytes(vm.envString("DEX"))) == keccak256(bytes("SushiswapDex"))) {
            SushiswapDex sushiswapDex = new SushiswapDex();
            console.log("SushiswapDex: ", address(sushiswapDex));
            IUniversalLiquidatorRegistry(_registry).addDex(keccak256(bytes(vm.envString("DEX_NAME"))), address(sushiswapDex));
            _newDex = address(sushiswapDex);
        } else if (keccak256(bytes(vm.envString("DEX"))) == keccak256(bytes("CurveDex"))) {
            CurveDex curveDex = new CurveDex();
            console.log("CurveDex: ", address(curveDex));
            IUniversalLiquidatorRegistry(_registry).addDex(keccak256(bytes(vm.envString("DEX_NAME"))), address(curveDex));
            _newDex = address(curveDex);
        } else if (keccak256(bytes(vm.envString("DEX"))) == keccak256(bytes("QuickswapDex"))) {
            QuickswapDex quickswapDex = new QuickswapDex();
            console.log("QuickswapDex: ", address(quickswapDex));
            IUniversalLiquidatorRegistry(_registry).addDex(keccak256(bytes(vm.envString("DEX_NAME"))), address(quickswapDex));
            _newDex = address(quickswapDex);
        } else {
            console.log("Dex not found");
        }
    }

    /**
     * @notice Check if the key exist in deployed-addresses.json file
     */
    function preDeploy() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/deployed-addresses.json");
        string memory json = vm.readFile(path);

        _registry = json.readAddress(string.concat(string.concat(".", vm.envString("NETWORK")), ".UniversalLiquidatorRegistry"));
        json.readString(string.concat(string.concat(".", vm.envString("NETWORK")), string.concat(".", vm.envString("DEX"))));
    }

    /**
     * @notice Write the deployed addresses to the deployed-addresses.json file
     */
    function postDeploy() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/deployed-addresses.json");

        string memory key = string.concat(string.concat(".", vm.envString("NETWORK")), string.concat(".", vm.envString("DEX")));
        string memory dexId = vm.envString("DEX_NAME");
        string memory dexAddr = uint256(uint160(_newDex)).toHexString(20);
        key.serialize("id", dexId);
        string memory value = key.serialize("address", dexAddr);
        value.write(path, key);
    }
}
