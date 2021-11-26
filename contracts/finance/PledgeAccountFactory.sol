// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import "./PledgedAccount.sol";


contract PledgedAccountFactory is Context, IERC777Recipient {
    IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);


    constructor() {
        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
    }


    function tokensReceived(
        address /* operator */,
        address from,
        address /* to */,
        uint256 amount,
        bytes calldata userData,
        bytes calldata /* operatorData */
    )
        external override
    {
        (address pledgeHolder) = abi.decode(userData, (address));

        address token = _msgSender();
        address pledgedAccount = address(new PledgedAccount(from, pledgeHolder, token));
        
        IERC777(token).send(pledgedAccount, amount, "");

        emit PledgedAccountCreated(pledgedAccount, pledgeHolder, from, token, amount); 
    }


    event PledgedAccountCreated(
        address pledgedAccount,
        address indexed pledgeHolder,
        address indexed pledger,
        address indexed shareToken,
        uint256 amount
    );
}