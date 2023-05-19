// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/console.sol";

// import test base and helpers.
import {AdvancedFixture} from "./AdvancedFixture.t.sol";

contract UniversalLiquidatorTest is AdvancedFixture {
    function setUp() public {
        // setup farmer, governance, and faucet

        // setup sellToken, buyToken, and whale

        //console.log(universalLiquidatorRegistry.getAllIntermediateTokens().length);
    }

    function testSwapWithSingleStep() public {}

    function testSwapWithMultihop() public {}

    function testSwapWithCrossDex() public {}

    function testCannotSwapWithPathUnset() public {}

    function testCannotSwapWithDexUnapproved() public {}

    function testCannotSwapWithInvalidMinBuyAmount() public {}
}
