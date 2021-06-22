// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts/access/AccessControl.sol";


abstract contract WhitelistController is AccessControl {

    bytes32 public constant WHITELIST_ADMIN_ROLE = keccak256("WHITELIST_ADMIN_ROLE");
    bytes32 public constant WHITELISTED_ROLE = keccak256("WHITELISTED_ROLE");


    modifier onlyToWhitelisted(
        address to
    ) {
        _checkRole(WHITELISTED_ROLE, to);
        _;
    }


    constructor(
        address issuer_,
        address[] memory defaultWhitelistAdmins_
    ) {
        _setRoleAdmin(WHITELISTED_ROLE, WHITELIST_ADMIN_ROLE);

        _setupRole(WHITELIST_ADMIN_ROLE, issuer_);
        _setupRole(WHITELISTED_ROLE, issuer_);

        for (uint i=0; i< defaultWhitelistAdmins_.length; i++) {
            _setupRole(WHITELIST_ADMIN_ROLE, defaultWhitelistAdmins_[i]);
        }
    }

    function isInWhitelist(
        address account
    )
        public view
        returns (bool)
    {
        return hasRole(WHITELISTED_ROLE, account);
    }
}