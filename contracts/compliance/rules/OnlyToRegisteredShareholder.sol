// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../../token/CMTA777/CMTA777Rule.sol";
import "../IShareholderRegister.sol";
import "./IOnlyToRegisteredShareholder.sol";


contract OnlyToRegisteredShareholder is IOnlyToRegisteredShareholder, CMTA777Rule {
    IShareholderRegister private immutable _shareholderRegister;

    constructor(
        address shareholderRegister_
    ) {
        require(shareholderRegister_ != address(0), "OnlyToRegisteredShareholder: shareholderRegister is the zero address");

        _shareholderRegister = IShareholderRegister(shareholderRegister_);
    }

    function shareholderRegister() 
        external view override
        returns (address)
    {
        return address(_shareholderRegister);
    }

    function _transferIsAllowed(
        address /* from */,
        address to,
        uint256 /* amount */
    )
        internal view override
        returns (bool)
    {
        return to == address(0) || _shareholderRegister.isShareholder(to);
    }

    function _violationMessage()
        internal pure override
        returns (string memory)
    {
        return "Beneficiary account should be included into the shareholder register";
    }
}