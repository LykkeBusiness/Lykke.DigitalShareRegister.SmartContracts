// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./ICMTA777Rule.sol";
import "./ICMTA777RuleEngine.sol";


abstract contract CMTA777RuleEngine is ICMTA777RuleEngine {
    using EnumerableSet for EnumerableSet.AddressSet;

    IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    bytes32 constant private _CMTA777_RULE_ENGINE_INTERFACE_HASH = keccak256("CMTA777RuleEngine");
    bytes32 constant private _CMTA777_RULE_INTERFACE_HASH = keccak256("CMTA777Rule");
    
    EnumerableSet.AddressSet private _rules;

    
    constructor(
        address[] memory defaultRules_
    ) {
        for (uint256 i = 0; i < defaultRules_.length; i++) {
            _addRule(defaultRules_[i]);
        }

        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), _CMTA777_RULE_ENGINE_INTERFACE_HASH, address(this));
    }

    function containsRule(
        address rule
    )
        external view override
        returns (bool)
    {
        return _rules.contains(rule);
    }

    function countRules()
        external view override
        returns (uint256)
    {
        return _rules.length();
    }

    function getViolationCode(
        uint256 ruleIndex,
        address from,
        address to,
        uint256 amount
    ) 
        external view override
        returns (uint256)
    {
        address implementer = _getRuleImplementer(ruleIndex);

        if (implementer != address(0)) {
            return ICMTA777Rule(implementer).getViolationCode(from, to, amount);
        } else {
            return 0;
        }
    }

    function getViolationMessage(
        uint256 ruleIndex,
        uint256 violationCode
    )
        external view override
        returns (string memory)
    {
        address implementer = _getRuleImplementer(ruleIndex);

        if (implementer != address(0)) {
            return ICMTA777Rule(implementer).getViolationMessage(violationCode);
        } else {
            return "";
        }
    }

    function ruleAt(
        uint256 index
    )
        external view override
        returns (address)
    {
        return _rules.at(index);
    }

    function transferIsAllowed(
        address from,
        address to,
        uint256 amount
    )
        external virtual view override
        returns (bool)
    {
        for (uint256 i = 0; i < _rules.length(); i++) {
            address implementer = _getRuleImplementer(i);

            if (implementer != address(0) && !ICMTA777Rule(implementer).transferIsAllowed(from, to, amount)) {
                return false;
            }
        }

        return true;
    }

    function _getRuleImplementer(
        uint256 ruleIndex
    )
        internal virtual view
        returns (address)
    {
        return _ERC1820_REGISTRY.getInterfaceImplementer(_rules.at(ruleIndex), _CMTA777_RULE_INTERFACE_HASH);
    }

    function _addRule(
        address rule
    )
        internal virtual 
        returns (bool)
    {
        address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(rule, _CMTA777_RULE_INTERFACE_HASH);

        require (implementer != address(0), "CMTA777RuleEngine: rule does not implement CMTA777Rule interface");
        
        bool ruleAdded = _rules.add(rule);
        if (ruleAdded) {
            emit RuleAdded(rule);
        }

        return ruleAdded;
    }

    function _removeRule(
        address rule
    )
        internal virtual
        returns (bool)
    {
        bool ruleRemoved = _rules.remove(rule);
        if (ruleRemoved) {
            emit RuleRemoved(rule);
        }

        return ruleRemoved;
    }
}