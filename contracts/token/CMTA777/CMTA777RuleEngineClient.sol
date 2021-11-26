// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import "./ICMTA777RuleEngine.sol";
import "./ICMTA777RuleEngineClient.sol";


abstract contract CMTA777RuleEngineClient is ICMTA777RuleEngineClient {
    bytes32 constant private _CMTA777_RULE_ENGINE_CLIENT_INTERFACE_HASH = keccak256("CMTA777RuleEngineClient");
    bytes32 constant private _CMTA777_RULE_ENGINE_INTERFACE_HASH = keccak256("CMTA777RuleEngine");
    IERC1820Registry constant private _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    address private _ruleEngine;


    constructor(
        address ruleEngine_
    ) {
        if (ruleEngine_ != address(0)) {
            _setRuleEngine(ruleEngine_);
        }

        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), _CMTA777_RULE_ENGINE_CLIENT_INTERFACE_HASH, address(this));
    }

    function canTransfer(
        address from,
        address to,
        uint256 amount
    )
        external view override
        returns (bool)
    {
        return _canTransfer(from, to, amount);
    }

    function ruleEngine() 
        external view override
        returns (address)
    {
        return _ruleEngine;
    }

    function _canTransfer(
        address from,
        address to,
        uint256 amount
    )
        internal virtual view
        returns (bool)
    {
        address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(_ruleEngine, _CMTA777_RULE_ENGINE_INTERFACE_HASH);

        if (implementer != address(0)) {
            return ICMTA777RuleEngine(implementer).transferIsAllowed(from, to, amount);
        } else {
            return true;
        }
    }

    function _setRuleEngine(
        address ruleEngine_
    )
        internal
    {
        address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(ruleEngine_, _CMTA777_RULE_ENGINE_INTERFACE_HASH);

        if (implementer != address(0)) {
            _ruleEngine = ruleEngine_;
            emit RuleEngineSet(ruleEngine_);
        } else {
            revert("CMTA777RuleEngineClient: ruleEngine_ does not implement CMTA777RuleEngine interface.");
        }
    }
}