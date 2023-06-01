// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// libraries
import "../../src/core/dexes/CurveDex.sol";

// import test base and helpers.
import {AdvancedFixture} from "../AdvancedFixture.t.sol";

contract CurveDexTest is AdvancedFixture {
    function testSetPoolId() public {
        // deploy dex
        startHoax(_governance);
        _curveDex = new CurveDex();
        _curveDex.setPool(_pools[1].sellToken, _pools[1].buyToken, address(bytes20(_pools[1].pools[0])));
        address pool = _curveDex.pool(_pools[1].sellToken, _pools[1].buyToken);
        assertEq(pool, address(bytes20(_pools[1].pools[0])));
        vm.stopPrank();
    }

    function testCannotSetPoolIdFromNonOwner() public {
        // deploy dex
        vm.prank(_governance);
        _curveDex = new CurveDex();
        vm.expectRevert("Ownable: caller is not the owner");
        _curveDex.setPool(_pools[1].sellToken, _pools[1].buyToken, address(bytes20(_pools[1].pools[0])));
        vm.prank(_governance);
        _curveDex.setPool(_pools[1].sellToken, _pools[1].buyToken, address(bytes20(_pools[1].pools[0])));
        address pool = _curveDex.pool(_pools[1].sellToken, _pools[1].buyToken);
        assertEq(pool, address(bytes20(_pools[1].pools[0])));
    }
}
