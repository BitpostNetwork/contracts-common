// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../interfaces/access/IOwnable.sol";

abstract contract Ownable is IOwnable {
    /// @custom:storage-location erc7201:bitpost.common.Ownable
    struct Storage_Ownable {
        address owner;
    }
    
    // keccak256(abi.encode(uint256(keccak256("bitpost.common.Ownable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION_OWNABLE = 0xbfdc26bbaea09886fc184fe4fcae59b15cffdf4b859be87d5955dbd541465600;
    
    modifier onlyOwner() {
        _checkOwner();
        _;
    }
    
    function _init_Ownable(address owner) internal {
        _setOwner(owner);
    }
    
    function getOwner() public view returns(address) {
        Storage_Ownable storage $ = _getStorage_Ownable();
        return $.owner;
    }
    
    function setOwner(address owner) external onlyOwner {
        _setOwner(owner);
    }
    
    function _setOwner(address owner) internal {
        require(owner != address(0), OwnableInvalidOwner(address(0)));
        Storage_Ownable storage $ = _getStorage_Ownable();
        $.owner = owner;
    }
    
    function _checkOwner() private view {
        Storage_Ownable storage $ = _getStorage_Ownable();
        require(msg.sender == $.owner, OwnableUnauthorized(msg.sender, $.owner));
    }
    
    function _getStorage_Ownable() private pure returns(Storage_Ownable storage $) {
        assembly {
            $.slot := STORAGE_LOCATION_OWNABLE
        }
    }
}
