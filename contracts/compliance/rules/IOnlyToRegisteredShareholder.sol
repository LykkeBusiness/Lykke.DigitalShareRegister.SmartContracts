// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../../token/CMTA777/ICMTA777Rule.sol";
import "../IShareholderRegister.sol";

interface IOnlyToRegisteredShareholder is ICMTA777Rule {

    function shareholderRegister() 
        external view
        returns (address);

}