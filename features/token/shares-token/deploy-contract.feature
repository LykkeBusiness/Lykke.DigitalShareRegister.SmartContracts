Feature: Deploy shares token smart contract
    
    Scenario: Deploying shares token smart contract
    
        When I deploy shares token smart contract with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        Then the transaction execution result is success    
    
    Scenario: Deploying shares token smart contract with an unspecified issuer
    
        When I deploy shares token smart contract with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | zero address |
        Then the transaction execution result is failure