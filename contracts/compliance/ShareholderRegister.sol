// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../access/OwnableBySharesTokenIssuer.sol";
import "./IShareholderRegister.sol";


contract ShareholderRegister is IShareholderRegister, OwnableBySharesTokenIssuer {
    using EnumerableSet for EnumerableSet.AddressSet;


    EnumerableSet.AddressSet private _shareholders;


    constructor(
        address sharesToken_
    ) 
        OwnableBySharesTokenIssuer(sharesToken_)
    {
        
    }


    function excludeShareholder(
        address shareholder
    )
        external override
        onlySharesTokenIssuer
        returns (bool)
    {
        bool shareholderExcluded = _shareholders.remove(shareholder);

        if (shareholderExcluded) {
            emit ShareholderExcluded(shareholder);
        }

        return shareholderExcluded;
    }

    function includeShareholder(
        address shareholder
    )
        external override
        onlySharesTokenIssuer
        returns (bool)
    {
        bool shareholderIncluded = _shareholders.add(shareholder);

        if (shareholderIncluded) {
            emit ShareholderIncluded(shareholder);
        }

        return shareholderIncluded;
    }

    function countShareholders()
        external view override
        returns (uint256)
    {
        return _shareholders.length();
    }

    function isShareholder(
        address account
    )
        external view override
        returns (bool)
    {
        return _shareholders.contains(account) || _isIssuer(account);
    }

    function shareholderAt(
        uint256 index
    )
        external view override
        returns (address)
    {
        return _shareholders.at(index);
    }

    function sharesToken() 
        public virtual view override(OwnableBySharesTokenIssuer, IShareholderRegister)
        returns (address) 
    {
        return super.sharesToken();
    }
}