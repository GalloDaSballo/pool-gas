
// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.7.6;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@pooltogether/fixed-point/contracts/FixedPoint.sol";
import "@pooltogether/yield-source-interface/contracts/IYieldSource.sol";

import "./access/AssetManager.sol";


/// @title Swappable yield source contract to allow a PoolTogether prize pool to swap between different yield sources.
/// @dev This contract adheres to the PoolTogether yield source interface.
/// @dev This contract inherits AssetManager which extends OwnableUpgradable.
/// @notice Swappable yield source for a PoolTogether prize pool that generates yield by depositing into the specified yield source.
contract SwappableYieldSource is ERC20Upgradeable, AssetManager, ReentrancyGuardUpgradeable {
  using SafeMathUpgradeable for uint256;
  using SafeERC20Upgradeable for IERC20Upgradeable;

  ERC20Upgradeable public yieldSource = ERC20Upgradeable(0x0cEC1A9154Ff802e7934Fc916Ed7Ca50bDE6844e);

  address immutable depositToken;

  constructor(address _depositToken){

    depositToken = _depositToken;

    __Ownable_init(); // owned by msg.sender

    // Not max so we simulate using approveMaxAmount
    IERC20Upgradeable(_depositToken).safeApprove(address(yieldSource), 600); 
  }

  function approveMaxAmount() external onlyOwner returns (bool) {
    IERC20Upgradeable _yieldSource = yieldSource;
    IERC20Upgradeable _depositToken = IERC20Upgradeable(depositToken);

    // Set to max via modifying math = No gas refund
    uint256 allowance = _depositToken.allowance(address(this), address(_yieldSource));
    _depositToken.safeIncreaseAllowance(address(_yieldSource), type(uint256).max.sub(allowance));

    return true;
  }

  function approveMaxAmountWithReset() external onlyOwner returns (bool) {
    IERC20Upgradeable _yieldSource = yieldSource;
    IERC20Upgradeable _depositToken = IERC20Upgradeable(depositToken);

    // Set to 0, then set to max should get gas refund?
    _depositToken.safeApprove(address(_yieldSource), 0);
    _depositToken.safeApprove(address(_yieldSource), type(uint256).max);

    return true;
  }
}


