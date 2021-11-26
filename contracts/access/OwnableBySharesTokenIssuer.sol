// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "../token/SharesToken.sol";
import "./IOwnableBySharesTokenIssuer.sol";


abstract contract OwnableBySharesTokenIssuer is IOwnableBySharesTokenIssuer, Context {
    using Address for address;

    SharesToken private immutable _sharesToken;


    constructor(
        address sharesToken_
    ) {
        require(
            sharesToken_ != address(0),
            "OwnableBySharesTokenIssuer: sharesToken_ is the zero address"
        );

        require(
            sharesToken_.isContract(),
            "OwnableBySharesTokenIssuer: sharesToken_ is not a contract"
        );

        _sharesToken = SharesToken(sharesToken_);
    }


    modifier onlySharesTokenIssuer {
        if (!_isIssuer(_msgSender())) {
            revert("OwnableBySharesTokenIssuer: message sender is not an issuer");
        }
        _;
    }


    function sharesToken()
        public virtual view override
        returns (address)
    {
        return address(_sharesToken);
    }

    function _isIssuer(
        address account
    )
        internal virtual view
        returns (bool)
    {
        return _sharesToken.hasRole(_sharesToken.ISSUER_ROLE(), account);
    }
}