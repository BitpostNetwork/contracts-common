// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../../contracts-vm/interfaces/IVersionManager.sol";

abstract contract Upgradeable {
    /// @custom:storage-location erc7201:bitpost.common.Upgradeable
    struct Storage_Upgradeable {
        IVersionManager versionManager;
        uint16 cid;
    }
    
    // keccak256(abi.encode(uint256(keccak256("bitpost.common.Upgradeable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION_UPGRADEABLE = 0x828626e98fd64181cb42e58a50c4931f9ea11da1800ee5ae64b4a2a58285ae00;
    
    function _init_Upgradeable(IVersionManager versionManager, uint16 cid) internal {
        Storage_Upgradeable storage $ = _getStorage_Upgradeable();
        $.versionManager = versionManager;
        $.cid = cid;
    }
    
    function _getVersionManager() internal view returns(IVersionManager) {
        Storage_Upgradeable storage $ = _getStorage_Upgradeable();
        return $.versionManager;
    }
    
    function _getCid() internal view returns(uint16) {
        Storage_Upgradeable storage $ = _getStorage_Upgradeable();
        return $.cid;
    }
    
    function _getStorage_Upgradeable() private pure returns(Storage_Upgradeable storage $) {
        assembly {
            $.slot := STORAGE_LOCATION_UPGRADEABLE
        }
    }
}
