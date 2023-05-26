// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./Types.t.sol";

abstract contract Fees {
    uint256 internal _feePairsCount;
    mapping(uint256 => Types.FeePair) internal _fees;

    constructor() {
        Types.FeePair storage newFee = _fees[_feePairsCount++];
        newFee.sellToken = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619; // DAI
        newFee.buyToken = 0xB0B195aEFA3650A6908f15CdaC7D92F8a5791B0B; // USDC
        newFee.dexName = "uniV3";
        newFee.fee = 500;
    }
}
