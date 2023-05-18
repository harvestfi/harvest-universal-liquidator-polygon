// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// import test base and helpers.
import {AdvancedFixture} from "./AdvancedFixture.t.sol";

contract UniversalLiquidatorTest is AdvancedFixture {
    function setUp() public {
        // setup farmer, governance, and faucet

        // setup sellToken, buyToken, and whale
        // deploy UL, ULR, and dexes

        // setup intermediate tokens
        // setup paths
        // setup fees
        // setup pools
    }

    function testSwapWithSingleStep() public {}

    function testSwapWithMultihop() public {}

    function testSwapWithCrossDex() public {}

    function testCannotSwapWithPathUnset() public {}

    function testCannotSwapWithDexUnapproved() public {}

    function testCannotSwapWithInvalidPath() public {}

    function testCannotSwapWithInvalidMinBuyAmount() public {}
}
