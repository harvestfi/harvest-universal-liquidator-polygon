// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// libraries
import "../../src/core/dexes/UniV3Dex.sol";

// import test base and helpers.
import {AdvancedFixture} from "../AdvancedFixture.t.sol";

contract CurveDexTest is AdvancedFixture {
    function testSetPoolFee() public {
        // deploy dex
        startHoax(_governance);
        _uniV3Dex = new UniV3Dex();
        _uniV3Dex.setFee(_fees[0].sellToken, _fees[0].buyToken, uint24(_fees[0].fee));
        uint24 fee = _uniV3Dex.pairFee(_fees[0].sellToken, _fees[0].buyToken);
        assertEq(fee, uint24(_fees[0].fee));
        vm.stopPrank();
    }

    function testCannotSetPoolFeeFromNonOwner() public {
        // deploy dex
        vm.prank(_governance);
        _uniV3Dex = new UniV3Dex();
        vm.expectRevert("Ownable: caller is not the owner");
        _uniV3Dex.setFee(_fees[0].sellToken, _fees[0].buyToken, uint24(_fees[0].fee));
        vm.prank(_governance);
        _uniV3Dex.setFee(_fees[0].sellToken, _fees[0].buyToken, uint24(_fees[0].fee));
        uint24 fee = _uniV3Dex.pairFee(_fees[0].sellToken, _fees[0].buyToken);
        assertEq(fee, uint24(_fees[0].fee));
    }
}
