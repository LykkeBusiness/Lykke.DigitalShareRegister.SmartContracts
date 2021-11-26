Feature: Only issuer can perform protected actions

    Scenario Outline: Calling a protected action
        Given shares token smart contract is deployed with the parameters:
            | Parameter   | Value        |
            | name        | Lykke Shares |
            | symbol      | LKK          |
            | issuer      | Alice        |
        And ownable by shares token issuer smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        When <user> calls for a protected action of the ownable by shares token issuer smart contract
        Then the transaction execution result is <result>
        Examples:
            | user   | result  |
            | Alice  | success |
            | Malory | failure |