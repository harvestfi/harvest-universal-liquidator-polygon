// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// interfaces
import "openzeppelin/token/ERC20/IERC20.sol";

// libraries
import "../src/core/dexes/UniV3Dex.sol";
import "../src/libraries/Errors.sol";

// import test base and helpers.
import {AdvancedFixture} from "./AdvancedFixture.t.sol";

contract UniversalLiquidatorRegistryTest is AdvancedFixture {
    function testSetPath() public {
        startHoax(_governance);
        // deploy new dex
        _setupDexes();
        // set pools fee
        _setupFees();
        // set path
        bytes32 dexId = _dexesByName[_singleTokenPairs[0].dexSetup[0].dexName].id;
        _universalLiquidatorRegistry.setPath(dexId, _singleTokenPairs[0].dexSetup[0].paths);
        vm.stopPrank();

        uint256 sellAmount = IERC20(_singleTokenPairs[0].sellToken).balanceOf(_singleTokenPairs[0].whale) / 100;
        uint256 minBuyAmount = 1;
        // whale transfer token to farmer
        address _farmer = makeAddr("farmer");
        vm.prank(_singleTokenPairs[0].whale);
        IERC20(address(_singleTokenPairs[0].sellToken)).transfer(_farmer, sellAmount);

        startHoax(_farmer);
        IERC20(_singleTokenPairs[0].sellToken).approve(address(_universalLiquidator), sellAmount);
        // execute swap
        uint256 receiveAmt = _universalLiquidator.swap(
            _singleTokenPairs[0].sellToken, _singleTokenPairs[0].buyToken, sellAmount, minBuyAmount, _farmer
        );
        assertLt(minBuyAmount, receiveAmt);
        vm.stopPrank();
    }

    function testSetIntermediateToken() public {
        startHoax(_governance);
        // deploy new dex
        _setupDexes();
        // set pools fee
        _setupFees();
        // set pools
        _setupPools();
        // set path
        for (uint256 j; j < _crossDexTokenPairs[0].dexSetup.length;) {
            bytes32 dexId = _dexesByName[_crossDexTokenPairs[0].dexSetup[j].dexName].id;
            _universalLiquidatorRegistry.setPath(dexId, _crossDexTokenPairs[0].dexSetup[j].paths);
            unchecked {
                ++j;
            }
        }
        vm.stopPrank();

        uint256 sellAmount = IERC20(_crossDexTokenPairs[0].sellToken).balanceOf(_crossDexTokenPairs[0].whale) / 100;
        uint256 minBuyAmount = 1;
        // whale transfer token to farmer
        address _farmer = makeAddr("farmer");
        vm.prank(_crossDexTokenPairs[0].whale);
        IERC20(address(_crossDexTokenPairs[0].sellToken)).transfer(_farmer, sellAmount);

        vm.prank(_farmer);
        IERC20(_crossDexTokenPairs[0].sellToken).approve(address(_universalLiquidator), sellAmount);
        // expect path not find because of intermediate tokens with execute swap
        vm.expectRevert(Errors.PathsNotExist.selector);
        vm.prank(_farmer);
        _universalLiquidator.swap(
            _crossDexTokenPairs[0].sellToken, _crossDexTokenPairs[0].buyToken, sellAmount, minBuyAmount, _farmer
        );
        // setup intermediate tokens
        vm.prank(_governance);
        _universalLiquidatorRegistry.setIntermediateToken(_intermediateTokens);
        // reexecute swap after setting up intermediate tokens
        vm.prank(_farmer);
        uint256 receiveAmt = _universalLiquidator.swap(
            _crossDexTokenPairs[0].sellToken, _crossDexTokenPairs[0].buyToken, sellAmount, minBuyAmount, _farmer
        );
        assertLt(minBuyAmount, receiveAmt);
    }

    function testAddNewDex() public {
        startHoax(_governance);
        // deploy dex
        _uniV3Dex = new UniV3Dex();
        // add dex
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
        // check dex with getAllDexes()
        bytes32[] memory dexes = _universalLiquidatorRegistry.getAllDexes();
        address dexAddress = _universalLiquidatorRegistry.dexesInfo(bytes32(bytes("uniV3")));
        assertEq(dexAddress, address(_uniV3Dex));
        assertEq(dexes[0], bytes32(bytes("uniV3")));
        vm.stopPrank();
    }

    function testChangeDexAddress() public {
        startHoax(_governance);
        // deploy dex
        _uniV3Dex = new UniV3Dex();
        _dexesByName["UniV3Dex"] = Dex(address(_uniV3Dex), bytes32(bytes("uniV3")));
        // add dex
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(makeAddr("mockDex")));
        // set path
        _universalLiquidatorRegistry.setPath(bytes32(bytes("uniV3")), _singleTokenPairs[0].dexSetup[0].paths);
        vm.stopPrank();

        uint256 sellAmount = IERC20(_singleTokenPairs[0].sellToken).balanceOf(_singleTokenPairs[0].whale) / 100;
        uint256 minBuyAmount = 1;
        // whale transfer token to farmer
        address _farmer = makeAddr("farmer");
        vm.prank(_singleTokenPairs[0].whale);
        IERC20(address(_singleTokenPairs[0].sellToken)).transfer(_farmer, sellAmount);

        vm.prank(_farmer);
        IERC20(_singleTokenPairs[0].sellToken).approve(address(_universalLiquidator), sellAmount);
        // expect tx to revert because of dex with address zero
        vm.expectRevert();
        vm.prank(_farmer);
        _universalLiquidator.swap(
            _singleTokenPairs[0].sellToken, _singleTokenPairs[0].buyToken, sellAmount, minBuyAmount, _farmer
        );
        // change dex address
        vm.prank(_governance);
        _universalLiquidatorRegistry.changeDexAddress(bytes32(bytes("uniV3")), address(_uniV3Dex));
        // set pools fee
        startHoax(_governance);
        _setupFees();
        vm.stopPrank();
        // reexecute swap after changing dex address
        vm.prank(_farmer);
        uint256 receiveAmt = _universalLiquidator.swap(
            _singleTokenPairs[0].sellToken, _singleTokenPairs[0].buyToken, sellAmount, minBuyAmount, _farmer
        );
        assertLt(minBuyAmount, receiveAmt);
    }

    function testCannotSetPathFromNonOwner() public {
        startHoax(_governance);
        // deploy new dex
        _setupDexes();
        // set pools fee
        _setupFees();
        // set path
        bytes32 dexId = _dexesByName[_singleTokenPairs[0].dexSetup[0].dexName].id;
        vm.stopPrank();

        vm.expectRevert("Ownable: caller is not the owner");
        _universalLiquidatorRegistry.setPath(dexId, _singleTokenPairs[0].dexSetup[0].paths);
    }

    function testCannotSetIntermediateTokenFromNonOwner() public {
        startHoax(_governance);
        // deploy new dex
        _setupDexes();
        // set pools fee
        _setupFees();
        // set pools
        _setupPools();
        vm.stopPrank();
        // set path
        for (uint256 i; i < _crossDexTokenPairs[0].dexSetup.length;) {
            bytes32 dexId = _dexesByName[_crossDexTokenPairs[0].dexSetup[i].dexName].id;
            vm.expectRevert("Ownable: caller is not the owner");
            _universalLiquidatorRegistry.setPath(dexId, _crossDexTokenPairs[0].dexSetup[i].paths);
            unchecked {
                ++i;
            }
        }
    }

    function testCannotAddNewDexFromNonOwner() public {
        // deploy dex
        vm.prank(_governance);
        _uniV3Dex = new UniV3Dex();
        // add dex
        vm.expectRevert("Ownable: caller is not the owner");
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
    }

    function testCannotChangeDexAddressFromNonOwner() public {
        startHoax(_governance);
        // deploy dex
        _uniV3Dex = new UniV3Dex();
        _dexesByName["UniV3Dex"] = Dex(address(_uniV3Dex), bytes32(bytes("uniV3")));
        // add dex
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(makeAddr("mockDex")));
        assertEq(_universalLiquidatorRegistry.dexesInfo(bytes32(bytes("uniV3"))), address(makeAddr("mockDex")));
        vm.stopPrank();
        // change dex address as non owner which should revert
        vm.expectRevert("Ownable: caller is not the owner");
        _universalLiquidatorRegistry.changeDexAddress(bytes32(bytes("uniV3")), address(_uniV3Dex));
        assertEq(_universalLiquidatorRegistry.dexesInfo(bytes32(bytes("uniV3"))), address(makeAddr("mockDex")));
        vm.prank(_governance);
        _universalLiquidatorRegistry.changeDexAddress(bytes32(bytes("uniV3")), address(_uniV3Dex));
        assertEq(_universalLiquidatorRegistry.dexesInfo(bytes32(bytes("uniV3"))), address(_uniV3Dex));
    }

    function testCannotSetPathIfDexNotExist() public {
        // set path
        vm.prank(_governance);
        vm.expectRevert(Errors.DexDoesNotExist.selector);
        _universalLiquidatorRegistry.setPath(bytes32(bytes("uniV3")), _singleTokenPairs[0].dexSetup[0].paths);

        startHoax(_governance);
        // deploy dex
        _uniV3Dex = new UniV3Dex();
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
        _universalLiquidatorRegistry.setPath(bytes32(bytes("uniV3")), _singleTokenPairs[0].dexSetup[0].paths);
        vm.stopPrank();
    }

    function testCannotAddNewDexIfDexNameExist() public {
        startHoax(_governance);
        // deploy dex
        _uniV3Dex = new UniV3Dex();
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
        vm.expectRevert(Errors.DexExists.selector);
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
        vm.stopPrank();
    }

    function testCannotChangeDexAddressIfDexNotExist() public {
        startHoax(_governance);
        // deploy dex
        _uniV3Dex = new UniV3Dex();
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
        vm.expectRevert(Errors.DexExists.selector);
        _universalLiquidatorRegistry.addDex(bytes32(bytes("uniV3")), address(_uniV3Dex));
        vm.stopPrank();
    }
}
