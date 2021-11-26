// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "CMTA20/contracts/interface/IContactable.sol";
import "CMTA20/contracts/interface/IIdentifiable.sol";
import "CMTA20/contracts/interface/IIssuable.sol";


interface ICMTA777 is IERC777, IContactable, IIdentifiable, IIssuable {
    event ContactSet(
        string contact
    );

    event IdentitySet(
        address indexed shareholder,
        bytes identity
    );
}