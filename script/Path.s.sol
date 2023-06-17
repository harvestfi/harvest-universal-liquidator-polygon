// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

import "../src/interfaces/IUniversalLiquidatorRegistry.sol";

struct DexSetting {
    string dexName;
    address[] paths;
}

struct TokenPair {
    address buyToken;
    string description;
    DexSetting[] dexSetup;
    address sellToken;
}

contract PathScript is Script {
    using stdJson for string;

    address _registry;
    string _json;
    string _config;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        TokenPair[] memory _tokenPairs = abi.decode(_config.parseRaw(""), (TokenPair[]));
        for (uint256 i; i < _tokenPairs.length;) {
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
        _json = vm.readFile(string.concat(vm.projectRoot(), "/script/deployed-addresses.json"));
        _config = vm.readFile(string.concat(vm.projectRoot(), "/script/config/", vm.envString("SETUP_FILE")));

        _registry = _json.readAddress(string.concat(".", vm.envString("NETWORK"), ".UniversalLiquidatorRegistry"));
    }
}
