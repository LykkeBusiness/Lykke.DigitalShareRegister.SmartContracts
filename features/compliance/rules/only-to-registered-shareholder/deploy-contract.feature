Feature: Deploying only to registered shareholder rule smart contract

    Scenario: Deploying only to registered shareholder rule smart contract with a shareholder contract address as a parameter
        
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        And shareholder register smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        When I deploy only to registered shareholder rule smart contract with the parameters:
            | Parameter            | Value                                          |
            | shareholder register | address of shareholder register smart contract |
        Then the transaction execution result is success

    Scenario: Deploying only to registered shareholder rule smart contract with zero address as a parameter

        When I deploy only to registered shareholder rule smart contract with the parameters:
            | Parameter            | Value        |
            | shareholder register | zero address |
        Then the transaction execution result is failure