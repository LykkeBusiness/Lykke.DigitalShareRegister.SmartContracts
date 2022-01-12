// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./CMTA777/CMTA777.sol";
import "./CMTA777/CMTA777RuleEngineClient.sol";


contract SharesToken is CMTA777, CMTA777RuleEngineClient {
    
    constructor(
        string memory name_,
        string memory symbol_,
        address issuer_
    )
        CMTA777(name_, symbol_, issuer_)
        CMTA777RuleEngineClient(address(0))
    {
        
    }

    // Begin CMTA777 overrides

    uint256 private constant _GRANULARITY = 10 ** 18;


    modifier onlyIntegerAmount(
        uint256 amount_
    ) {
        require(amount_ % _GRANULARITY == 0, "SharesToken: shares are not divisible");
        _;
    }


    function granularity() 
        public virtual view override
        returns (uint256) 
    {
        return _GRANULARITY;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256 amount
    ) 
        internal virtual override
        onlyIntegerAmount(amount)
        onlyWithinAvailableBalance(from, amount)
    {
        require(_canTransfer(from, to, amount), "SharesToken: transfer is not allowed");

        super._beforeTokenTransfer(operator, from, to, amount);
    }

    // End CMTA777 overrides

    // Begin CMTA777RuleEngineClient overrides and implementation

    function setRuleEngine(
        address ruleEngine_
    )
        external
        onlyRole(ISSUER_ROLE)
    {
        _setRuleEngine(ruleEngine_);
    }

    // End CMTA777RuleEngineClient overrides and implementation

    // Begin seizure procedure implementation

    struct SeizureProcedure {
        address account;
        uint256 amount;
        uint256 timelock;
        uint256 expiration;
    }

    mapping(address => uint256) private _frozenBalances;
    uint256 private _seizureProcedureIdGenerator;
    mapping(uint256 => SeizureProcedure) private _seizureProcedures;


    modifier onlyWithinAvailableBalance(
        address owner,
        uint256 amount
    ) {
        require(owner == address(0) || availableBalanceOf(owner) >= amount, "SharesToken: amount exceeds available balance");
        _;
    }

    function availableBalanceOf(
        address owner
    )
        public view
        returns (uint256)
    {
        return balanceOf(owner) - frozenBalanceOf(owner);
    }

    function frozenBalanceOf(
        address owner
    )
        public view
        returns (uint256)
    {
        return _frozenBalances[owner];
    }

    function cancelSeizureProcedure(
        uint256 procedureId
    )
        external
    {
        SeizureProcedure memory procedure = _getSeizureProcedure(procedureId);
        
        if (block.timestamp <= procedure.expiration) {
            _checkRole(ISSUER_ROLE, _msgSender());
        }

        _frozenBalances[procedure.account] -= procedure.amount;
        delete _seizureProcedures[procedureId];

        emit SeizureProcedureCancelled(procedureId, procedure.account, procedure.amount);
    }

    function executeSeizureProcedure(
        uint256 procedureId,
        address beneficiary
    )
        external
        onlyRole(ISSUER_ROLE)
    {
        SeizureProcedure memory procedure = _getSeizureProcedure(procedureId);

        require(block.timestamp > procedure.timelock, "SharesToken: seizure procedure is in locked state");

        _frozenBalances[procedure.account] -= procedure.amount;
        _send(procedure.account, beneficiary, procedure.amount, "", "", true);
        delete _seizureProcedures[procedureId];

        emit SeizureProcedureExecuted(procedureId, procedure.account, procedure.amount, beneficiary);
    }

    function initiateSeizureProcedure(
        address account,
        uint256 amount,
        uint256 delay,
        uint256 duration
    )
        external
        onlyRole(ISSUER_ROLE)
        onlyIntegerAmount(amount)
        onlyWithinAvailableBalance(account, amount)
        returns (uint256)
    {
        require(account != address(0), "SharesToken: account is the zero address");
        require(amount != 0, "SharesToken: amount is equal to zero");

        uint256 procedureId = ++_seizureProcedureIdGenerator;
        uint256 timelock = block.timestamp + delay;
        uint256 expiration = timelock + duration;

        SeizureProcedure memory procedure = SeizureProcedure(account, amount, timelock, expiration);

        _frozenBalances[account] += procedure.amount;
        _seizureProcedures[procedureId] = procedure;

        emit SeizureProcedureInitiated(procedureId, account, amount, timelock, expiration);

        return procedureId;
    }

    function _getSeizureProcedure(
        uint256 procedureId
    )
        private view
        returns (SeizureProcedure memory)
    {
        SeizureProcedure memory procedure = _seizureProcedures[procedureId];
        
        require(procedure.account != address(0), "SharesToken: seizure procedure does not exist or completed");

        return procedure;
    }


    event SeizureProcedureInitiated(
        uint256 indexed id,
        address indexed account,
        uint256 amount,
        uint256 timelock,
        uint256 expiration
    );

    event SeizureProcedureCancelled(
        uint256 indexed id,
        address indexed account,
        uint256 amount
    );

    event SeizureProcedureExecuted(
        uint256 indexed id,
        address indexed account,
        uint256 amount,
        address beneficiary
    );

    // End seizure procedure implementation
}