// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface ICMTA777RuleEngineClient {
    function canTransfer(
        address from,
        address to,
        uint256 amount
    )
        external view
        returns (bool);

    function ruleEngine() 
        external view 
        returns (address);

    event RuleEngineSet(
        address indexed ruleEngine
    );
}