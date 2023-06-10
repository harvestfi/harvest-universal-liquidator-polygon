// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

import "./config/Pools.sol";

contract PoolScript is Script, Pools {
    using stdJson for string;

    string _json;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        for (uint256 i; i < _poolPairsCount;) {
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
                        address(bytes20(_pools[i].pools[0]))
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
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/deployed-addresses.json");
        _json = vm.readFile(path);
    }
}
