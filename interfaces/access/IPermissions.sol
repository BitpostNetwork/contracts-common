// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

interface IPermissions {
    error PermissionsUnauthorized(address user, uint16 permissions, uint16 required);
    error PermissionsInvalidUser(address user);
    error PermissionsNotChanged(address user, uint16 permissions);
    error PermissionsLockoutPrevented(address owner);
    
    function getUsers(uint8 limit, uint256 offset) external view returns(address[] memory);
    function getPermissions(address user) external view returns(uint16);
    function setPermissions(address user, uint16 permissions) external;
}
