Feature: Get shares token address

    Scenario: Getting shares token address
        Given shares token smart contract is deployed with the parameters:
            | Parameter   | Value        |
            | name        | Lykke Shares |
            | symbol      | LKK          |
            | issuer      | Alice        |
        And ownable by shares token issuer smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        When I call ownable by shares token issuer smart contract for shares token address
        Then the call result is the address of shares token smart contract