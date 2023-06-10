// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

import "../src/interfaces/IUniversalLiquidatorRegistry.sol";

import "./config/Paths.sol";

contract PathScript is Script, Paths {
    using stdJson for string;

    address _registry;
    string _json;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        for (uint256 i; i < _tokenPairCount;) {
            for (uint256 j; j < _tokenPairs[i].dexSetup.length;) {
                string memory _dexName =
                    _json.readString(string.concat(".", vm.envString("NETWORK"), ".", _tokenPairs[i].dexSetup[j].dexName, ".id"));
                bytes32 dexId = bytes32(bytes(_dexName));
                IUniversalLiquidatorRegistry(_registry).setPath(dexId, _tokenPairs[i].dexSetup[j].paths);
                unchecked {
                    ++j;
                }
            }

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Check if the key exist in deployed-addresses.json file
     */
    function preDeploy() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/deployed-addresses.json");
        _json = vm.readFile(path);

        _registry = _json.readAddress(string.concat(string.concat(".", vm.envString("NETWORK")), ".UniversalLiquidatorRegistry"));
    }
}
