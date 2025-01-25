// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "../../interfaces/access/IPermissions.sol";

abstract contract Permissions is IPermissions {
    /// @custom:storage-location erc7201:bitpost.common.Permissions
    struct Storage_Permissions {
        mapping(address => uint16) permissions;
        address[] users;
        mapping(address => uint256) userIndex;
        uint256 ownerCount;
    }
    
    // keccak256(abi.encode(uint256(keccak256("bitpost.common.Permissions")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION_PERMISSIONS = 0x68fe19185e240d9214875be5b2b0c87a4a5a1d49f09c1a0b6456c42cbedb1e00;
    
    uint16 internal constant PERM_NONE = 0x0000;
    uint16 internal constant PERM_OWNER = 0x8000;
    uint8 internal constant SP_FLAG_INIT = 0x01;
    
    modifier perm(uint16 permissions) {
        _checkPermissions(permissions);
        _;
    }
    
    function _init_Permissions(address owner, uint16 ownerPermissions) internal {
        _setPermissions(owner, PERM_OWNER | ownerPermissions, SP_FLAG_INIT);
    }
    
    function getUsers(uint8 limit, uint256 offset) public view returns(address[] memory) {
        Storage_Permissions storage $ = _getStorage_Permissions();
        
        uint256 totalCount = $.users.length;
        if(offset >= totalCount) {
            return new address[](0);
        }
        
        uint256 end = offset + limit;
        if(end > totalCount) {
            end = totalCount;
        }
        uint256 resultCount = end - offset;

        address[] memory result = new address[](resultCount);
        for(uint256 i = 0; i < resultCount; i++) {
            result[i] = $.users[offset + i];
        }
        return result;
    }
    
    function getPermissions(address user) public view returns(uint16) {
        require(user != address(0), PermissionsInvalidUser(address(0)));
        
        Storage_Permissions storage $ = _getStorage_Permissions();
        return $.permissions[user];
    }
    
    function setPermissions(address user, uint16 permissions) external perm(PERM_OWNER) {
        _setPermissions(user, permissions, 0);
    }
    
    function _setPermissions(address user, uint16 permissions, uint8 flags) internal virtual {
        uint16 oldPermissions = getPermissions(user);
        require(oldPermissions != permissions, PermissionsNotChanged(user, oldPermissions));
        
        Storage_Permissions storage $ = _getStorage_Permissions();
        
        if((oldPermissions & PERM_OWNER != 0) && (permissions & PERM_OWNER == 0)) {
            require($.ownerCount > 1, PermissionsLockoutPrevented(user));
            $.ownerCount--;
        } else if((oldPermissions & PERM_OWNER == 0) && (permissions & PERM_OWNER != 0)) {
            $.ownerCount++;
        }
        
        if(oldPermissions == PERM_NONE) {
            _addUser(user, flags);
        }
        else if(permissions == PERM_NONE) {
            _removeUser(user, flags);
        }
        
        $.permissions[user] = permissions;
    }
    
    function _addUser(address user, uint8) internal virtual {
        Storage_Permissions storage $ = _getStorage_Permissions();
        
        $.userIndex[user] = $.users.length;
        $.users.push(user);
    }
    
    function _removeUser(address user, uint8) internal virtual {
        Storage_Permissions storage $ = _getStorage_Permissions();
        
        address lastUser = $.users[$.users.length - 1];
        if(user != lastUser) {
            uint256 midIndex = $.userIndex[user];
            $.users[midIndex] = lastUser;
            $.userIndex[lastUser] = midIndex;
        }
            
        $.users.pop();
        delete $.userIndex[user];
    }
    
    function _checkPermissions(uint16 permissions) private view {
        Storage_Permissions storage $ = _getStorage_Permissions();
        require(
            $.permissions[msg.sender] & permissions == permissions,
            PermissionsUnauthorized(msg.sender, $.permissions[msg.sender], permissions)
        );
    }
    
    function _getStorage_Permissions() private pure returns(Storage_Permissions storage $) {
        assembly {
            $.slot := STORAGE_LOCATION_PERMISSIONS
        }
    }
}
