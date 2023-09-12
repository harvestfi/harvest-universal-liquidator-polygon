// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// imported contracts and libraries
import "openzeppelin/access/Ownable.sol";
import "openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin/token/ERC20/IERC20.sol";

// interfaces
import "../../interfaces/ILiquidityDex.sol";
import "../../interfaces/pearl/IRouter.sol";

// libraries
import "../../libraries/Addresses.sol";

// constants and types
import {PearlDexStorage} from "../storage/PearlDex.sol";

contract PearlDex is Ownable, ILiquidityDex, PearlDexStorage {
    using SafeERC20 for IERC20;

    function doSwap(uint256 _sellAmount, uint256 _minBuyAmount, address _receiver, address[] memory _path)
        external
        override
        returns (uint256)
    {
        address sellToken = _path[0];

        IERC20(sellToken).safeIncreaseAllowance(Addresses.pearlRouter, _sellAmount);

        IRouter.Route[] memory routes = new IRouter.Route[](_path.length-1);
        for (uint256 idx = 0; idx < _path.length - 1; idx++) {
            routes[idx].from = _path[idx];
            routes[idx].to = _path[idx + 1];
            routes[idx].stable = stable(_path[idx], _path[idx + 1]);
        }

        uint256[] memory returned = IRouter(Addresses.pearlRouter).swapExactTokensForTokens(
            _sellAmount, _minBuyAmount, routes, _receiver, block.timestamp
        );

        return returned[returned.length - 1];
    }

    function pairSetup(address _token0, address _token1, bool _stable) external onlyOwner {
        _pairStable[_token0][_token1] = _stable;
        _pairStable[_token1][_token0] = _stable;
    }

    function stable(address _token0, address _token1) public view returns (bool) {
        return _pairStable[_token0][_token1];
    }

    receive() external payable {}
}
