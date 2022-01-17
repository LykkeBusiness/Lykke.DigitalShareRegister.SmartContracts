// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../access/OwnableBySharesTokenIssuer.sol";

contract OwnableBySharesTokenIssuerMock is OwnableBySharesTokenIssuer {

    constructor(
        address sharesToken_
    ) 
        OwnableBySharesTokenIssuer(sharesToken_)
    {
        
    }

    function functionCallableOnlyBySharesTokenIssuer()
        external
        onlySharesTokenIssuer
    {

    }
}