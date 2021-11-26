// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";


contract PledgedAccount is Context {
    IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    address immutable _pledgeHolder;
    address immutable _pledger;
    address immutable _token;


    constructor(
        address pledgeHolder_,
        address pledger_,
        address token_
    ) {
        _pledgeHolder = pledgeHolder_;
        _pledger = pledger_;
        _token = token_;


        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
    }


    function refundPledge(
        string calldata reason
    )
        external
    {
        require(_msgSender() == _pledgeHolder, "PledgedAccount: message sender is not a pledge holder.");

        uint256 amount = _closeAccount(_pledger);

        emit PledgeRefunded(_pledgeHolder, _pledger, _token, amount, reason);
    }

    function settlePledge(
        string calldata reason
    )
        external
    {
        require(_msgSender() == _pledger, "PledgedAccount: message sender is not a pledger.");

        uint256 amount = _closeAccount(_pledgeHolder);

        emit PledgeSettled(_pledgeHolder, _pledger, _token, amount, reason);
    }

    function _closeAccount(
        address beneficiary
    )
        private
        returns (uint256)
    {
        IERC777 token = IERC777(_token);
        uint256 amount = token.balanceOf(address(this));

        token.send(beneficiary, amount, "");

        return amount;
    }


    event PledgeRefunded(
        address indexed pledgeHolder,
        address indexed pledger,
        address indexed token,
        uint256 amount,
        string reason
    );

    event PledgeSettled(
        address indexed pledgeHolder,
        address indexed pledger,
        address indexed token,
        uint256 amount,
        string reason
    );
}