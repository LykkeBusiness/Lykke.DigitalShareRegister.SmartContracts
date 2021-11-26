// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface ICMTA777RuleEngine {
    function containsRule(
        address rule
    )
        external view
        returns (bool);

    function countRules()
        external view
        returns (uint256);

    function getViolationCode(
        uint256 ruleIndex,
        address from,
        address to,
        uint256 amount
    ) 
        external view 
        returns (uint256);

    function getViolationMessage(
        uint256 ruleIndex,
        uint256 violationCode
    )
        external view
        returns (string memory);

    function ruleAt(
        uint256 index
    )
        external view
        returns (address);

    function transferIsAllowed(
        address from,
        address to,
        uint256 amount
    )
        external view 
        returns (bool);


    event RuleAdded(
        address indexed rule
    );

    event RuleRemoved(
        address indexed rule
    );
}