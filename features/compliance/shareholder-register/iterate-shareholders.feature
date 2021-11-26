Feature: Iterate thru shareholder list

    Background:
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        And shareholder register smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        And Alice included Bob into shareholder register
        And Alice included Charlie into shareholder register
        And Alice included Frank into shareholder register
        And Alice included Grace into shareholder register
        And Alice included Judy into shareholder register


    Scenario: Counting shareholders
        When I call shareholder register smart contract for the number of shareholders
        Then the call result is equal to 5

    Scenario Outline: Getting shareholder by index
        When I call shareholder register smart contract for the shareholder with index <index>
        And the call result is the address of <shareholder>

        Examples:
        | index | shareholder |
        | 0     | Bob         |
        | 1     | Charlie     |
        | 2     | Frank       |
        | 3     | Grace       |
        | 4     | Judy        |