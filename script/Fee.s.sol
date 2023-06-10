// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

import "./config/Fees.sol";

contract FeeScript is Script, Fees {
    using stdJson for string;

    string _json;

    function run() public {
        vm.startBroadcast();
        preDeploy();
        deploy();
        vm.stopBroadcast();
    }

    function deploy() public {
        for (uint256 i; i < _feePairsCount;) {
            string memory dexName = _fees[i].dexName;
            address _dexAddr = _json.readAddress(string.concat(".", vm.envString("NETWORK"), ".", dexName, ".address"));
            if (keccak256(bytes(dexName)) == keccak256(bytes("UniV3Dex"))) {
                (bool success, bytes memory data) = _dexAddr.call(
                    abi.encodeWithSignature("setFee(address,address,uint24)", _fees[i].sellToken, _fees[i].buyToken, _fees[i].fee)
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
