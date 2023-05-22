// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/console2.sol";

// interfaces
import "openzeppelin/token/ERC20/IERC20.sol";

// import test base and helpers.
import {AdvancedFixture} from "./AdvancedFixture.t.sol";

contract UniversalLiquidatorTest is AdvancedFixture {
    uint256 _polygonFork;
    address _farmer;

    function setUp() public {
        // fork testing environment
        _polygonFork = vm.createFork(_POLYGON_RPC_URL);
        vm.selectFork(_polygonFork);
        // mock farmer address
        _farmer = makeAddr("farmer");
    }

    function testSwapWithSingleStep() public {
        for (uint256 i; i < _singleTokenPairCount;) {
            // whale transfer token to farmer
            uint256 sellAmount = IERC20(_singleTokenPairs[i].sellToken).balanceOf(_singleTokenPairs[0].whale);
            vm.prank(_singleTokenPairs[0].whale);
            IERC20(address(_singleTokenPairs[0].sellToken)).transfer(_farmer, sellAmount);

            // check farmer, deployedDex, and ul token balance
            assertEq(sellAmount, IERC20(_singleTokenPairs[i].sellToken).balanceOf(_farmer));
            assertEq(0, IERC20(_singleTokenPairs[i].sellToken).balanceOf(address(_universalLiquidator)));
            assertEq(0, IERC20(_singleTokenPairs[i].buyToken).balanceOf(_farmer));
            assertEq(0, IERC20(_singleTokenPairs[i].buyToken).balanceOf(address(_universalLiquidator)));

            uint256 requiredDex = _singleTokenPairs[i].dexSetup.length;
            for (uint256 j; j < requiredDex;) {
                address deployedDex = _dexesByName[_singleTokenPairs[i].dexSetup[j].dexName].addr;
                assertEq(0, IERC20(_singleTokenPairs[i].sellToken).balanceOf(deployedDex));
                assertEq(0, IERC20(_singleTokenPairs[i].buyToken).balanceOf(deployedDex));
                unchecked {
                    ++j;
                }
            }
            // approve ul as farmer
            // swap
            // check farmer, deployedDex, and ul token balance
            unchecked {
                ++i;
            }
        }
    }

    function testSwapWithMultihop() public {}

    function testSwapWithCrossDex() public {}

    function testCannotSwapWithPathUnset() public {}

    function testCannotSwapWithDexUnapproved() public {}

    function testCannotSwapWithInvalidMinBuyAmount() public {}
}
