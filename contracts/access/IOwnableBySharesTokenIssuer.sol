// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import "../token/SharesToken.sol";


interface IOwnableBySharesTokenIssuer {

    function sharesToken()
        external view
        returns (address);

}