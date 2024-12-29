// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

interface IInitializable {
    error InitializableAlreadyInitialized();
    error InitializableRequiredVersion(uint256 currentVersion, uint256 requiredVersion);
    error InitializableMinimalVersion(uint256 currentVersion, uint256 minimalVersion);
    
    function getVersion() external view returns(uint256);
}
