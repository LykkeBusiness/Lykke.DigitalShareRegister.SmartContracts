Feature: Deploy ownable by shares token issuer smart contract

    Scenario: Deploying contract with the zero address as a shares token address
        When I deploy ownable by shares token issuer smart contract with the parameters:
            | Parameter    | Value        |
            | shares token | zero address |
        Then the transaction execution result is failure

    Scenario: Deploying contract with a non-contract address as a shares token address
        When I deploy ownable by shares token issuer smart contract with the parameters:
            | Parameter    | Value      |
            | shares token | my address |
        Then the transaction execution result is failure

    Scenario: Deploying contract with a contract address as a shares token address
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        When I deploy ownable by shares token issuer smart contract with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        Then the transaction execution result is success