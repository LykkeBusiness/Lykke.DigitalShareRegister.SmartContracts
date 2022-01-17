Feature: Issue shares

    Scenario Outline: Issuing shares
        Given shares token smart contract is deployed with the parameters:
            | Parameter   | Value        |
            | name        | Lykke Shares |
            | symbol      | LKK          |
            | issuer      | Alice        |
        When <user> issues 42000000000000000000 shares
        Then the transaction execution result is <result>
        Examples:
            | user   | result  |
            | Alice  | success |
            | Malory | failure |