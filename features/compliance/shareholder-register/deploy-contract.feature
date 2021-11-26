Feature: Deploy shareholder register smart contract
    
    Scenario: Deploying contract with a contract address as a shares token address
    
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        When I deploy shareholder register smart contract with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        Then the transaction execution result is success    