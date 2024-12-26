// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

interface IOwnable {
    error OwnableUnauthorized(address sender, address owner);
    error OwnableInvalidOwner(address owner);
    
    function getOwner() external view returns(address);
    function setOwner(address owner) external;
}
