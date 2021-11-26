// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../access/OwnableBySharesTokenIssuer.sol";
import "./CMTA777/CMTA777RuleEngine.sol";


contract SharesTokenRuleEngine is CMTA777RuleEngine, OwnableBySharesTokenIssuer {

    constructor(
        address sharesToken_
    )
        CMTA777RuleEngine(new address[](0))
        OwnableBySharesTokenIssuer(sharesToken_)
    {
        
    }


    function addRule(
        address rule
    )
        external
        onlySharesTokenIssuer
        returns (bool)
    {
        return _addRule(rule);
    }

    function removeRule(
        address rule
    )
        external
        onlySharesTokenIssuer
        returns (bool)
    {
        return _removeRule(rule);
    }
}