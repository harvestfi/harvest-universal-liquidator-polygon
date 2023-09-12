// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

abstract contract PearlDexStorage {
    mapping(address => mapping(address => bool)) internal _pairStable;
}
