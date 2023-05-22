// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract SingleSwapPaths {
    uint256 internal _tokenPairCount;
    mapping(uint256 => Types.TokenPair) internal _tokenPairs;

    constructor() {
        address[] memory _path = new address[](2);

        _path[0] = 0xB4a925BAe55743AcF3Dc65a8de0b9507F0491617;
        _path[1] = 0x288071244112050c93389A950d02c9E626D611dD;

        Types.TokenPair storage newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH
        newTokenPair.buyToken = 0x912CE59144191C1204E64559FE8253a0e49E6548; // ARB
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xC6d973B31BB135CaBa83cf0574c0347BD763ECc5;
        newTokenPair.dexSetup.push(Types.DexSetting("uniV3", _path));

        _path[0] = 0x5979D7b546E38E414F7E9822514be443A4800529;
        _path[1] = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0x5979D7b546E38E414F7E9822514be443A4800529; // wstETH
        newTokenPair.buyToken = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xD090D2C8475c5eBdd1434A48897d81b9aAA20594;
        newTokenPair.dexSetup.push(Types.DexSetting("balancer", _path));

        _path[0] = 0xd4d42F0b6DEF4CE0383636770eF773390d85c61A;
        _path[1] = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0xd4d42F0b6DEF4CE0383636770eF773390d85c61A; // SUSHI
        newTokenPair.buyToken = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0x1714400FF23dB4aF24F9fd64e7039e6597f18C2b;
        newTokenPair.dexSetup.push(Types.DexSetting("sushi", _path));

        _path[0] = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
        _path[1] = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;

        newTokenPair = _tokenPairs[_tokenPairCount++];
        newTokenPair.sellToken = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT
        newTokenPair.buyToken = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // USDC
        newTokenPair.intermediateToken = address(0);
        newTokenPair.whale = 0xf89d7b9c864f589bbF53a82105107622B35EaA40;
        newTokenPair.dexSetup.push(Types.DexSetting("curve", _path));
    }
}
