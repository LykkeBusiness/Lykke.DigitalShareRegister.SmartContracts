// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface IShareholderRegister {

    function excludeShareholder(
        address shareholder
    )
        external
        returns (bool);

    function includeShareholder(
        address shareholder
    )
        external
        returns (bool);

    function countShareholders()
        external view
        returns (uint256);

    function isShareholder(
        address account
    )
        external view
        returns (bool);

    function shareholderAt(
        uint256 index
    )
        external view
        returns (address);

    function sharesToken()
        external view
        returns (address);


    event ShareholderIncluded(
        address indexed shareholder
    );

    event ShareholderExcluded(
        address indexed shareholder
    );
    
}