// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// libraries
import "../../src/core/dexes/BalancerDex.sol";

// import test base and helpers.
import {AdvancedFixture} from "../AdvancedFixture.t.sol";

contract BalancerDexTest is AdvancedFixture {
// function testSetPoolId() public {
//     // deploy dex
//     startHoax(_governance);
//     _balancerDex = new BalancerDex();
//     _balancerDex.setPool(_pools[0].sellToken, _pools[0].buyToken, _pools[0].pools);
//     bytes32[] memory pools = _balancerDex.pool(_pools[0].sellToken, _pools[0].buyToken);
//     for (uint256 idx; idx < pools.length;) {
//         assertEq(pools[idx], _pools[0].pools[idx]);
//         unchecked {
//             ++idx;
//         }
//     }
//     vm.stopPrank();
// }

// function testCannotSetPoolIdFromNonOwner() public {
//     // deploy dex
//     vm.prank(_governance);
//     _balancerDex = new BalancerDex();
//     vm.expectRevert("Ownable: caller is not the owner");
//     _balancerDex.setPool(_pools[0].sellToken, _pools[0].buyToken, _pools[0].pools);
//     vm.prank(_governance);
//     _balancerDex.setPool(_pools[0].sellToken, _pools[0].buyToken, _pools[0].pools);
//     bytes32[] memory pools = _balancerDex.pool(_pools[0].sellToken, _pools[0].buyToken);
//     for (uint256 idx; idx < pools.length;) {
//         assertEq(pools[idx], _pools[0].pools[idx]);
//         unchecked {
//             ++idx;
//         }
//     }
// }
}
