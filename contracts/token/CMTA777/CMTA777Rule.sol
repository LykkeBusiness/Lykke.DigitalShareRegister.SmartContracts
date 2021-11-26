// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import "./ICMTA777Rule.sol";


abstract contract CMTA777Rule is ICMTA777Rule {
    IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    bytes32 constant private _CMTA777_RULE_INTERFACE_HASH = keccak256("CMTA777Rule");

    constructor() {
        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), _CMTA777_RULE_INTERFACE_HASH, address(this));
    }


    function getViolationCode(
        address from,
        address to,
        uint256 amount
    ) 
        external virtual view override
        returns (uint256)
    {
        return _transferIsAllowed(from, to, amount) ? 0 : _violationCode();
    }

    function getViolationMessage(
        uint256 violationCode
    )
        external virtual view override
        returns (string memory)
    {
        return _violationCode() == violationCode ? _violationMessage() : "Unknown violation code.";
    }

    function transferIsAllowed(
        address from,
        address to,
        uint256 amount
    )
        external view override
        returns (bool)
    {
        return _transferIsAllowed(from, to, amount);
    }

    function _transferIsAllowed(
        address from,
        address to,
        uint256 amount
    )
        internal virtual view
        returns (bool);

    function _violationCode()
        internal virtual view
        returns (uint8)
    {
        return 1;
    }

    function _violationMessage()
        internal virtual view
        returns (string memory);
}