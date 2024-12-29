// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../interfaces/upgrade/IInitializable.sol";

abstract contract Initializable is IInitializable {
    /// @custom:storage-location erc7201:bitpost.common.Initializable
    struct Storage_Initializable {
        uint256 version;
    }
    
    // keccak256(abi.encode(uint256(keccak256("bitpost.common.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION_INITIALIZABLE = 0xf9388d16ccb89f8ceeb8bce5074db391472ebb34229a1051e19fc642d992d400;
       
    modifier initVer(uint256 version) {
        Storage_Initializable storage $ = _getStorage_Initializable();
        require($.version == 0, InitializableAlreadyInitialized());
        _;
        $.version = version;
    }
    
    modifier upVer(uint256 version) {
        Storage_Initializable storage $ = _getStorage_Initializable();
        require($.version == version - 1, InitializableRequiredVersion($.version, version - 1));
        _;
        $.version = version;
    }
    
    modifier minVer(uint256 version) {
        _checkMinVer(version);
        _;
    }
    
    function getVersion() public view returns(uint256) {
        Storage_Initializable storage $ = _getStorage_Initializable();
        return $.version;
    }
    
    function _checkMinVer(uint256 version) private view {
        Storage_Initializable storage $ = _getStorage_Initializable();
        require($.version >= version, InitializableMinimalVersion($.version, version));
    }
    
    function _getStorage_Initializable() private pure returns(Storage_Initializable storage $) {
        assembly {
            $.slot := STORAGE_LOCATION_INITIALIZABLE
        }
    }
}
