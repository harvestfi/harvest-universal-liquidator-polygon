// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract Fees {
    uint256 internal _feePairsCount;
    mapping(uint256 => Types.FeePair) internal _fees;

    constructor() {
        Types.FeePair storage newFee = _fees[_feePairsCount++];
        newFee.sellToken = 0x040d1EdC9569d4Bab2D15287Dc5A4F10F56a56B8; // DAI
        newFee.buyToken = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // USDC
        newFee.dexName = "uniV3";
        newFee.fee = 500;
    }
}
