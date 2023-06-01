// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// interfaces
import "openzeppelin/token/ERC20/IERC20.sol";

// libraries
import "../src/libraries/Errors.sol";

// import test base and helpers.
import {AdvancedFixture} from "./AdvancedFixture.t.sol";

contract UniversalLiquidatorTest is AdvancedFixture {
    address _farmer;

    constructor() {
        startHoax(_governance);
        _setupDexes();
        // setup intermediate tokens
        _universalLiquidatorRegistry.setIntermediateToken(_intermediateTokens);
        // setup fees
        _setupFees();
        // setup pools
        _setupPools();
        vm.stopPrank();
    }

    function setUp() public {
        // mock farmer address
        _farmer = makeAddr("farmer");
    }

    function _preSwapCheck(
        address _sellToken,
        address _buyToken,
        address _whale,
        DexSetting[] memory _dexSetup,
        uint256 _sellAmount
    ) internal {
        vm.prank(_whale);
        IERC20(address(_sellToken)).transfer(_farmer, _sellAmount);

        // check farmer, deployedDex, and ul token balance
        assertEq(_sellAmount, IERC20(_sellToken).balanceOf(_farmer));
        assertEq(0, IERC20(_sellToken).balanceOf(address(_universalLiquidator)));
        assertEq(0, IERC20(_buyToken).balanceOf(_farmer));
        assertEq(0, IERC20(_buyToken).balanceOf(address(_universalLiquidator)));

        _dexEmptyCheck(_sellToken, _buyToken, _dexSetup);
    }

    function _postSwapCheck(
        address _sellToken,
        address _buyToken,
        DexSetting[] memory _dexSetup,
        uint256 _minBuyAmount,
        uint256 _receiveAmt
    ) internal {
        // check farmer, deployedDex, and ul token balance
        assertEq(0, IERC20(_sellToken).balanceOf(_farmer));
        assertEq(0, IERC20(_sellToken).balanceOf(address(_universalLiquidator)));

        uint256 postSwapBalance = IERC20(_buyToken).balanceOf(_farmer);
        assertLt(_minBuyAmount, _receiveAmt);
        assertLt(_minBuyAmount, postSwapBalance);
        assertEq(postSwapBalance, _receiveAmt);
        assertEq(0, IERC20(_buyToken).balanceOf(address(_universalLiquidator)));

        _dexEmptyCheck(_sellToken, _buyToken, _dexSetup);
    }

    function _dexEmptyCheck(address _sellToken, address _buyToken, DexSetting[] memory _dexSetup) internal {
        for (uint256 j; j < _dexSetup.length;) {
            address deployedDex = _dexesByName[_dexSetup[j].dexName].addr;
            assertEq(0, IERC20(_sellToken).balanceOf(deployedDex));
            assertEq(0, IERC20(_buyToken).balanceOf(deployedDex));
            unchecked {
                ++j;
            }
        }
    }

    function _happyPathSwap(address _sellToken, address _buyToken, address _whale, DexSetting[] memory _dexSetup) internal {
        for (uint256 j; j < _dexSetup.length;) {
            bytes32 dexId = _dexesByName[_dexSetup[j].dexName].id;
            vm.prank(_governance);
            _universalLiquidatorRegistry.setPath(dexId, _dexSetup[j].paths);
            unchecked {
                ++j;
            }
        }

        // whale transfer token to farmer
        uint256 sellAmount = IERC20(_sellToken).balanceOf(_whale) / 100;
        uint256 minBuyAmount = 1;

        _preSwapCheck(_sellToken, _buyToken, _whale, _dexSetup, sellAmount);

        // approve ul as farmer
        startHoax(_farmer);
        IERC20(_sellToken).approve(address(_universalLiquidator), sellAmount);
        // swap
        uint256 receiveAmt = _universalLiquidator.swap(_sellToken, _buyToken, sellAmount, minBuyAmount, _farmer);

        _postSwapCheck(_sellToken, _buyToken, _dexSetup, minBuyAmount, receiveAmt);
        vm.stopPrank();
    }

    function _swapWithoutPaths(address _sellToken, address _buyToken, address _whale, DexSetting[] memory _dexSetup) internal {
        // whale transfer token to farmer
        uint256 sellAmount = IERC20(_sellToken).balanceOf(_whale) / 100;
        uint256 minBuyAmount = 1;

        _preSwapCheck(_sellToken, _buyToken, _whale, _dexSetup, sellAmount);

        // approve ul as farmer
        startHoax(_farmer);
        IERC20(_sellToken).approve(address(_universalLiquidator), sellAmount);
        // swap
        vm.expectRevert(Errors.PathsNotExist.selector);
        _universalLiquidator.swap(_sellToken, _buyToken, sellAmount, minBuyAmount, _farmer);
        vm.stopPrank();
    }

    function _swapWithoutApproval(address _sellToken, address _buyToken, address _whale, DexSetting[] memory _dexSetup)
        internal
    {
        // whale transfer token to farmer
        uint256 sellAmount = IERC20(_sellToken).balanceOf(_whale) / 100;
        uint256 minBuyAmount = 1;

        _preSwapCheck(_sellToken, _buyToken, _whale, _dexSetup, sellAmount);

        // approve ul as farmer
        startHoax(_farmer);
        // swap
        vm.expectRevert();
        _universalLiquidator.swap(_sellToken, _buyToken, sellAmount, minBuyAmount, _farmer);
        vm.stopPrank();
    }

    function _swapWithoutMaxMinBuyAmount(address _sellToken, address _buyToken, address _whale, DexSetting[] memory _dexSetup)
        internal
    {
        for (uint256 j; j < _dexSetup.length;) {
            bytes32 dexId = _dexesByName[_dexSetup[j].dexName].id;
            vm.prank(_governance);
            _universalLiquidatorRegistry.setPath(dexId, _dexSetup[j].paths);
            unchecked {
                ++j;
            }
        }

        // whale transfer token to farmer
        uint256 sellAmount = 1;
        uint256 minBuyAmount = uint256(type(int256).max);

        _preSwapCheck(_sellToken, _buyToken, _whale, _dexSetup, sellAmount);

        // approve ul as farmer
        startHoax(_farmer);
        IERC20(_sellToken).approve(address(_universalLiquidator), sellAmount);
        // swap
        vm.expectRevert();
        _universalLiquidator.swap(_sellToken, _buyToken, sellAmount, minBuyAmount, _farmer);
        vm.stopPrank();
    }

    function testSwap() public {
        for (uint256 i; i < _singleTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _happyPathSwap(
                _singleTokenPairs[i].sellToken,
                _singleTokenPairs[i].buyToken,
                _singleTokenPairs[i].whale,
                _singleTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _multiTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _happyPathSwap(
                _multiTokenPairs[i].sellToken,
                _multiTokenPairs[i].buyToken,
                _multiTokenPairs[i].whale,
                _multiTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _crossDexTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _happyPathSwap(
                _crossDexTokenPairs[i].sellToken,
                _crossDexTokenPairs[i].buyToken,
                _crossDexTokenPairs[i].whale,
                _crossDexTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }

    function testCannotSwapWithPathUnset() public {
        for (uint256 i; i < _singleTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutPaths(
                _singleTokenPairs[i].sellToken,
                _singleTokenPairs[i].buyToken,
                _singleTokenPairs[i].whale,
                _singleTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _multiTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutPaths(
                _multiTokenPairs[i].sellToken,
                _multiTokenPairs[i].buyToken,
                _multiTokenPairs[i].whale,
                _multiTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _crossDexTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutPaths(
                _crossDexTokenPairs[i].sellToken,
                _crossDexTokenPairs[i].buyToken,
                _crossDexTokenPairs[i].whale,
                _crossDexTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }

    function testCannotSwapWithDexUnapproved() public {
        for (uint256 i; i < _singleTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutApproval(
                _singleTokenPairs[i].sellToken,
                _singleTokenPairs[i].buyToken,
                _singleTokenPairs[i].whale,
                _singleTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _multiTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutApproval(
                _multiTokenPairs[i].sellToken,
                _multiTokenPairs[i].buyToken,
                _multiTokenPairs[i].whale,
                _multiTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _crossDexTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutApproval(
                _crossDexTokenPairs[i].sellToken,
                _crossDexTokenPairs[i].buyToken,
                _crossDexTokenPairs[i].whale,
                _crossDexTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }

    function testCannotSwapWithInvalidMinBuyAmount() public {
        for (uint256 i; i < _singleTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutMaxMinBuyAmount(
                _singleTokenPairs[i].sellToken,
                _singleTokenPairs[i].buyToken,
                _singleTokenPairs[i].whale,
                _singleTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _multiTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutMaxMinBuyAmount(
                _multiTokenPairs[i].sellToken,
                _multiTokenPairs[i].buyToken,
                _multiTokenPairs[i].whale,
                _multiTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }

        for (uint256 i; i < _crossDexTokenPairCount;) {
            uint256 snapshot = vm.snapshot();

            _swapWithoutMaxMinBuyAmount(
                _crossDexTokenPairs[i].sellToken,
                _crossDexTokenPairs[i].buyToken,
                _crossDexTokenPairs[i].whale,
                _crossDexTokenPairs[i].dexSetup
            );

            unchecked {
                ++i;
            }
            vm.revertTo(snapshot);
        }
    }
}
