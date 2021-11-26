// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;


interface ICMTA777Rule {
    function getViolationCode(
        address from,
        address to,
        uint256 amount
    ) 
        external view 
        returns (uint256);

    function getViolationMessage(
        uint256 violationCode
    )
        external view
        returns (string memory);

    function transferIsAllowed(
        address from,
        address to,
        uint256 amount
    )
        external view
        returns (bool);
}