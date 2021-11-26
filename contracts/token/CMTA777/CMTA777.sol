// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "./ICMTA777.sol";


abstract contract CMTA777 is AccessControl, ERC777, Pausable, ICMTA777 {
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");

    constructor(
        string memory name_,
        string memory symbol_,
        address issuer_
    )
        ERC777(name_, symbol_, new address[](0))
    {
        require(issuer_ != address(0), "CMTA777: issuer is the zero address");

        _setRoleAdmin(ISSUER_ROLE, ISSUER_ROLE);
        
        _setupRole(ISSUER_ROLE, issuer_);
    }

    // Begin ERC777 overrides

    function totalSupply() 
        public virtual view override(ERC777, IERC777)
        returns (uint256) 
    {
        return super.totalSupply();
    }

    function balanceOf(
        address tokenHolder
    ) 
        public virtual view override(ERC777, IERC777)
        returns (uint256)
    {
        return super.balanceOf(tokenHolder);
    }

    function burn(
        uint256 amount,
        bytes memory data
    )
        public virtual override(ERC777, IERC777)
        onlyRole(ISSUER_ROLE)
    {
        super.burn(amount, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256 amount
    ) 
        internal virtual override
        whenNotPaused
    {
        super._beforeTokenTransfer(operator, from, to, amount);
    }

    // End ERC777 overrides

    // Begin IContactable implementation

    string private _contact;

    function contact() 
        external view override
        returns (string memory)
    {
        return _contact;
    }

    function setContact(
        string calldata contact_
    ) 
        external
        onlyRole(ISSUER_ROLE)
    {
        _contact = contact_;

        emit ContactSet(contact_);
    }

    // End IContactable implementation

    // Begin IIdentifiable implementation

    mapping(address => bytes) private _identities;

    function identity(
        address shareholder
    )
        external view override
        returns (bytes memory)
    {
        return _identities[shareholder];
    }
    
    function setMyIdentity(
        bytes calldata identity_
    )
        external override
    {
        _identities[_msgSender()] = identity_;
        
        emit IdentitySet(_msgSender(), identity_);
    }

    // End IIdentifiable implementation

    // Begin IIssuable implementation

    function issue(
        uint256 amount
    )
        external override
        onlyRole(ISSUER_ROLE)
    {
        _mint(_msgSender(), amount, "", "");
    }

    // End IIssuable implementation

    // Begin Pausable implementation

    function pause()
        external virtual
        onlyRole(ISSUER_ROLE)
        whenNotPaused
    {
        _pause();
    }

    function unpause()
        external virtual
        onlyRole(ISSUER_ROLE)
        whenPaused
    {
        _unpause();
    }

    // End Pausable implementation
}