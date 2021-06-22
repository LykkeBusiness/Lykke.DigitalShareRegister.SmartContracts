// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";


abstract contract CancellationsController is AccessControl {
    using EnumerableSet for EnumerableSet.UintSet;

    struct Cancellation {
        address account;
        uint256 amount;
        uint256 timestamp;
    }

    event CancellationExecuted(
        uint256 indexed id,
        address indexed account,
        address indexed to,
        uint256 amount,
        uint256 timestamp
    );

    event CancellationInitialized(
        uint256 indexed id,
        address indexed account,
        uint256 amount,
        uint256 timestamp
    );

    event CancellationRevoked(
        uint256 indexed id,
        address indexed account,
        uint256 amount,
        uint256 timestamp
    );

    modifier onlyCancellationAdmin() {
        _checkRole(CANCELLATION_ADMIN_ROLE, _msgSender());
        _;
    }

    modifier onlyIfCancellationExists(
        uint256 cancellationId
    ) {
        require(_cancellationIds.contains(cancellationId), "CancellationsController: cancellation has not been found.");
        _;
    }
    

    bytes32 public constant CANCELLATION_ADMIN_ROLE = keccak256("CANCELLATION_ADMIN_ROLE");

    uint256 private _cancellationIdGenerator;
    EnumerableSet.UintSet private _cancellationIds;
    mapping (uint256 => Cancellation) private _cancellations;
    mapping (address => uint256) private _lockedBalances;


    constructor(
        address issuer_,
        address[] memory defaultCancellationAdmins_
    ) {
        _setupRole(CANCELLATION_ADMIN_ROLE, issuer_);

        for (uint i=0; i< defaultCancellationAdmins_.length; i++) {
            _setupRole(CANCELLATION_ADMIN_ROLE, defaultCancellationAdmins_[i]);
        }
    }

    function countCancellations()
        public view
        returns (uint256)
    {
        return _cancellationIds.length();
    }

    function getCancellation(
        uint256 cancellationId
    )
        public view
        onlyIfCancellationExists(cancellationId)
        returns (uint256 id, address account, uint256 amount , uint256 timestamp)
    {
        Cancellation memory cancellation = _cancellations[cancellationId];
        
        return (cancellationId, cancellation.account, cancellation.amount, cancellation.timestamp);
    }

    function getCancellationAt(
        uint256 cancellationIndex
    )
        public view
        returns (uint256 id, address account, uint256 amount , uint256 timestamp)
    {
        uint256 cancellationId = _cancellationIds.at(cancellationIndex);
        Cancellation memory cancellation = _cancellations[cancellationId];
        
        return (cancellationId, cancellation.account, cancellation.amount, cancellation.timestamp);
    }

    function lockedBalanceOf(
        address tokenHolder
    )
        public view 
        returns (uint256)
    {
        return _lockedBalances[tokenHolder];
    }

    function executeCancellation(
        uint256 cancellationId,
        address to
    )
        public
        onlyCancellationAdmin()
        onlyIfCancellationExists(cancellationId)
    {
        Cancellation memory cancellation = _cancellations[cancellationId];
        
        require(cancellation.timestamp <= block.timestamp, "CancellationsController: cancellation is locked.");

        _unlockBalance(cancellation);
        _executeCancellation(cancellation.account, cancellation.amount, to);
        _removeCancellation(cancellationId);

        emit CancellationExecuted(cancellationId, cancellation.account, to, cancellation.amount, cancellation.timestamp);
    }

    function initCancellation(
        address account,
        uint256 amount,
        uint256 timestamp
    )
        public
        onlyCancellationAdmin()
        returns (uint256)
    {
        require(timestamp > block.timestamp, "CancellationsController: timestamp is in the past.");

        _beforeInitCancellation(account, amount);

        uint256 cancellationId = ++_cancellationIdGenerator;
        
        _cancellations[cancellationId] = Cancellation(account, amount, timestamp);
        _cancellationIds.add(cancellationId);
        _lockedBalances[account] += amount;

        emit CancellationInitialized(cancellationId, account, amount, timestamp);

        return cancellationId;
    }

    function revokeCancellation(
        uint256 cancellationId
    )
        public
        onlyCancellationAdmin()
        onlyIfCancellationExists(cancellationId)
    {
        Cancellation memory cancellation = _cancellations[cancellationId];

        _unlockBalance(cancellation);
        _removeCancellation(cancellationId);

        emit CancellationRevoked(cancellationId, cancellation.account, cancellation.amount, cancellation.timestamp);
    }

    function _beforeInitCancellation(
        address account,
        uint256 amount
    )
        internal virtual
    {
        
    }

    function _executeCancellation(
        address account,
        uint256 amount,
        address to
    ) 
        internal virtual
    {
        
    }

    function _removeCancellation(
        uint256 cancellationId
    )
        private
    {
        delete _cancellations[cancellationId];
        _cancellationIds.remove(cancellationId);
    }

    function _unlockBalance(
        Cancellation memory cancellation
    )
        private
    {
        _lockedBalances[cancellation.account] -= cancellation.amount;
    }
}