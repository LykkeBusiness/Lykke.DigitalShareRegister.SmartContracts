Feature: Check if address belongs to a shareholder

    Scenario Outline: Checking if address belongs to a shareholder
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        And shareholder register smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        And Alice included Bob into shareholder register
        When I call shareholder register smart contract if <account> is a shareholder
        And the call result is <result>

        Examples:
        | account | result |
        | Bob     | true   |
        | Charlie | false  |