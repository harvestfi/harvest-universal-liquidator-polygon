// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

struct PoolPair {
    address buyToken;
    string description;
    string dexName;
    bytes32[] pools;
    address sellToken;
}

contract PoolScript is Script {
    using stdJson for string;

    string _json;
    string _config;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        PoolPair[] memory _pools = abi.decode(_config.parseRaw(""), (PoolPair[]));
        for (uint256 i; i < _pools.length;) {
            string memory dexName = _pools[i].dexName;
            address _dexAddr = _json.readAddress(string.concat(".", vm.envString("NETWORK"), ".", dexName, ".address"));
            if (keccak256(bytes(dexName)) == keccak256(bytes("BalancerDex"))) {
                (bool success, bytes memory data) = _dexAddr.call(
                    abi.encodeWithSignature(
                        "setPool(address,address,bytes32[])", _pools[i].sellToken, _pools[i].buyToken, _pools[i].pools
                    )
                );
                if (!success) {
                    console2.log("curve setPool failed: ");
                    console2.logBytes(data);
                }
            } else if (keccak256(bytes(dexName)) == keccak256(bytes("CurveDex"))) {
                (bool success, bytes memory data) = _dexAddr.call(
                    abi.encodeWithSignature(
                        "setPool(address,address,address)",
                        _pools[i].sellToken,
                        _pools[i].buyToken,
                        address(uint160(uint256(_pools[i].pools[0])))
                    )
                );
                if (!success) {
                    console2.log("curve setPool failed: ");
                    console2.logBytes(data);
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
    }
}
