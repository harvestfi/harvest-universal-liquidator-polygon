// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract SingleSwapPaths {
    uint256 internal _singleTokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _singleTokenPairs;

    constructor() {
        address[] memory _path = new address[](2);

        _path[0] = 0xB4a925BAe55743AcF3Dc65a8de0b9507F0491617;
        _path[1] = 0x288071244112050c93389A950d02c9E626D611dD;

        Types.TokenPair storage newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619; // WETH
        newTokenPair.buyToken = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B; // BOB
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x62ac55b745F9B08F1a81DCbbE630277095Cf4Be1;
        newTokenPair.dexSetup.push(Types.DexSetting("uniV3", _path));

        _path[0] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
        _path[1] = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B;

        /*
        newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0x5979D7b546E38E414F7E9822514be443A4800529; // wstETH
        newTokenPair.buyToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619; // WETH
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xD090D2C8475c5eBdd1434A48897d81b9aAA20594;
        newTokenPair.dexSetup.push(Types.DexSetting("balancer", _path));

        _path[0] = 0xd4d42F0b6DEF4CE0383636770eF773390d85c61A;
        _path[1] = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;

        newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0xd4d42F0b6DEF4CE0383636770eF773390d85c61A; // SUSHI
        newTokenPair.buyToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619; // WETH
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x1714400FF23dB4aF24F9fd64e7039e6597f18C2b;
        newTokenPair.dexSetup.push(Types.DexSetting("sushi", _path));

        _path[0] = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
        _path[1] = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;

        newTokenPair = _singleTokenPairs[_singleTokenPairCount++];
        newTokenPair.sellToken = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT
        newTokenPair.buyToken = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // USDC
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xf89d7b9c864f589bbF53a82105107622B35EaA40;
        newTokenPair.dexSetup.push(Types.DexSetting("curve", _path));
        */
    }
}
