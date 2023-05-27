// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

// interfaces
import "openzeppelin/token/ERC20/IERC20.sol";

// import test base and helpers.
import {AdvancedFixture} from "./AdvancedFixture.t.sol";

contract UniversalLiquidatorTest is AdvancedFixture {
    address _farmer;

    function setUp() public {
        // mock farmer address
        _farmer = makeAddr("farmer");
    }

    function testSwapWithSingleStep() public {
        for (uint256 i; i < _singleTokenPairCount;) {
            uint256 snapshot = vm.snapshot();
            // whale transfer token to farmer
            uint256 sellAmount = IERC20(_singleTokenPairs[i].sellToken).balanceOf(_singleTokenPairs[i].whale) / 100;
            uint256 minBuyAmount = 1; // * 10 ** 18;
            vm.prank(_singleTokenPairs[i].whale);
            IERC20(address(_singleTokenPairs[i].sellToken)).transfer(_farmer, sellAmount);

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
            startHoax(_farmer);
            IERC20(_singleTokenPairs[i].sellToken).approve(address(_universalLiquidator), sellAmount);
            // swap
            uint256 receiveAmt = _universalLiquidator.swap(
                _singleTokenPairs[i].sellToken, _singleTokenPairs[i].buyToken, sellAmount, minBuyAmount, _farmer
            );
            // check farmer, deployedDex, and ul token balance
            assertEq(0, IERC20(_singleTokenPairs[i].sellToken).balanceOf(_farmer));
            assertEq(0, IERC20(_singleTokenPairs[i].sellToken).balanceOf(address(_universalLiquidator)));

            uint256 postSwapBalance = IERC20(_singleTokenPairs[i].buyToken).balanceOf(_farmer);
            assertLt(minBuyAmount, receiveAmt);
            assertLt(minBuyAmount, postSwapBalance);
            assertEq(postSwapBalance, receiveAmt);
            assertEq(0, IERC20(_singleTokenPairs[i].buyToken).balanceOf(address(_universalLiquidator)));

            for (uint256 j; j < requiredDex;) {
                address deployedDex = _dexesByName[_singleTokenPairs[i].dexSetup[j].dexName].addr;
                assertEq(0, IERC20(_singleTokenPairs[i].sellToken).balanceOf(deployedDex));
                assertEq(0, IERC20(_singleTokenPairs[i].buyToken).balanceOf(deployedDex));
                unchecked {
                    ++j;
                }
            }
            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }

    function testSwapWithMultihop() public {
        for (uint256 i; i < _multiTokenPairCount;) {
            uint256 snapshot = vm.snapshot();
            // whale transfer token to farmer
            uint256 sellAmount = IERC20(_multiTokenPairs[i].sellToken).balanceOf(_multiTokenPairs[i].whale) / 100;
            uint256 minBuyAmount = 1; // * 10 ** 18;
            vm.prank(_multiTokenPairs[i].whale);
            IERC20(address(_multiTokenPairs[i].sellToken)).transfer(_farmer, sellAmount);

            // check farmer, deployedDex, and ul token balance
            assertEq(sellAmount, IERC20(_multiTokenPairs[i].sellToken).balanceOf(_farmer));
            assertEq(0, IERC20(_multiTokenPairs[i].sellToken).balanceOf(address(_universalLiquidator)));
            assertEq(0, IERC20(_multiTokenPairs[i].buyToken).balanceOf(_farmer));
            assertEq(0, IERC20(_multiTokenPairs[i].buyToken).balanceOf(address(_universalLiquidator)));

            uint256 requiredDex = _multiTokenPairs[i].dexSetup.length;
            for (uint256 j; j < requiredDex;) {
                address deployedDex = _dexesByName[_multiTokenPairs[i].dexSetup[j].dexName].addr;
                assertEq(0, IERC20(_multiTokenPairs[i].sellToken).balanceOf(deployedDex));
                assertEq(0, IERC20(_multiTokenPairs[i].buyToken).balanceOf(deployedDex));
                unchecked {
                    ++j;
                }
            }
            // approve ul as farmer
            startHoax(_farmer);
            IERC20(_multiTokenPairs[i].sellToken).approve(address(_universalLiquidator), sellAmount);
            // swap
            uint256 receiveAmt = _universalLiquidator.swap(
                _multiTokenPairs[i].sellToken, _multiTokenPairs[i].buyToken, sellAmount, minBuyAmount, _farmer
            );
            // check farmer, deployedDex, and ul token balance
            assertEq(0, IERC20(_multiTokenPairs[i].sellToken).balanceOf(_farmer));
            assertEq(0, IERC20(_multiTokenPairs[i].sellToken).balanceOf(address(_universalLiquidator)));

            uint256 postSwapBalance = IERC20(_multiTokenPairs[i].buyToken).balanceOf(_farmer);
            assertLt(minBuyAmount, receiveAmt);
            assertLt(minBuyAmount, postSwapBalance);
            assertEq(postSwapBalance, receiveAmt);
            assertEq(0, IERC20(_multiTokenPairs[i].buyToken).balanceOf(address(_universalLiquidator)));

            for (uint256 j; j < requiredDex;) {
                address deployedDex = _dexesByName[_multiTokenPairs[i].dexSetup[j].dexName].addr;
                assertEq(0, IERC20(_multiTokenPairs[i].sellToken).balanceOf(deployedDex));
                assertEq(0, IERC20(_multiTokenPairs[i].buyToken).balanceOf(deployedDex));
                unchecked {
                    ++j;
                }
            }
            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }

    function testSwapWithCrossDex() public {
        for (uint256 i; i < _crossDexTokenPairCount;) {
            uint256 snapshot = vm.snapshot();
            // whale transfer token to farmer
            uint256 sellAmount = IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(_crossDexTokenPairs[i].whale) / 100;
            uint256 minBuyAmount = 1; // * 10 ** 18;
            vm.prank(_crossDexTokenPairs[i].whale);
            IERC20(address(_crossDexTokenPairs[i].sellToken)).transfer(_farmer, sellAmount);

            // check farmer, deployedDex, and ul token balance
            assertEq(sellAmount, IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(_farmer));
            assertEq(0, IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(address(_universalLiquidator)));
            assertEq(0, IERC20(_crossDexTokenPairs[i].buyToken).balanceOf(_farmer));
            assertEq(0, IERC20(_crossDexTokenPairs[i].buyToken).balanceOf(address(_universalLiquidator)));

            uint256 requiredDex = _crossDexTokenPairs[i].dexSetup.length;
            for (uint256 j; j < requiredDex;) {
                address deployedDex = _dexesByName[_crossDexTokenPairs[i].dexSetup[j].dexName].addr;
                assertEq(0, IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(deployedDex));
                assertEq(0, IERC20(_crossDexTokenPairs[i].buyToken).balanceOf(deployedDex));
                unchecked {
                    ++j;
                }
            }
            // approve ul as farmer
            startHoax(_farmer);
            IERC20(_crossDexTokenPairs[i].sellToken).approve(address(_universalLiquidator), sellAmount);
            // swap
            uint256 receiveAmt = _universalLiquidator.swap(
                _crossDexTokenPairs[i].sellToken, _crossDexTokenPairs[i].buyToken, sellAmount, minBuyAmount, _farmer
            );
            // check farmer, deployedDex, and ul token balance
            assertEq(0, IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(_farmer));
            assertEq(0, IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(address(_universalLiquidator)));

            uint256 postSwapBalance = IERC20(_crossDexTokenPairs[i].buyToken).balanceOf(_farmer);
            assertLt(minBuyAmount, receiveAmt);
            assertLt(minBuyAmount, postSwapBalance);
            assertEq(postSwapBalance, receiveAmt);
            assertEq(0, IERC20(_crossDexTokenPairs[i].buyToken).balanceOf(address(_universalLiquidator)));

            for (uint256 j; j < requiredDex;) {
                address deployedDex = _dexesByName[_crossDexTokenPairs[i].dexSetup[j].dexName].addr;
                assertEq(0, IERC20(_crossDexTokenPairs[i].sellToken).balanceOf(deployedDex));
                assertEq(0, IERC20(_crossDexTokenPairs[i].buyToken).balanceOf(deployedDex));
                unchecked {
                    ++j;
                }
            }
            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }

    function testCannotSwapWithPathUnset() public {}

    function testCannotSwapWithDexUnapproved() public {}

    function testCannotSwapWithInvalidMinBuyAmount() public {}
}
