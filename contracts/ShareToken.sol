// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "./CancellationsController.sol";
import "./WhitelistController.sol";

contract ShareToken is ERC777, CancellationsController, WhitelistController {
    
    modifier onlyIfHasSufficientAvailableBalance(
        address account,
        uint256 amount
    ) {
        require(amount <= availableBalanceOf(account), "ShareToken: specified amount exceeds available balance.");
        _;
    }

    constructor(
        address issuer_,
        uint256 initialSupply_,
        string memory name_,
        string memory symbol_,
        address[] memory defaultCancellationAdmins_,
        address[] memory defaultWhitelistAdmins_,
        address[] memory defaultOperators_
    ) 
        ERC777(name_, symbol_, defaultOperators_)
        CancellationsController(issuer_, defaultCancellationAdmins_)
        WhitelistController(issuer_, defaultWhitelistAdmins_)
    {
        _setupRole(DEFAULT_ADMIN_ROLE, issuer_);
        _mint(issuer_, initialSupply_, "", "");
    }

    function availableBalanceOf(
        address tokenHolder
    ) 
        public view
        returns (uint256)
    {
        return balanceOf(tokenHolder) - lockedBalanceOf(tokenHolder);
    }

    function _beforeInitCancellation(
        address account,
        uint256 amount
    )
        internal view override
        onlyIfHasSufficientAvailableBalance(account, amount)
    {
        
    }

    function _beforeTokenTransfer(
        address,
        address from,
        address to,
        uint256 amount
    )
        internal view override
        onlyToWhitelisted(to)
        onlyIfHasSufficientAvailableBalance(from, amount)
    {
        
    }

    function _executeCancellation(
        address account,
        uint256 amount,
        address to
    ) 
        internal override
    {
        _send(account, to, amount, "", "", true);
    }
}