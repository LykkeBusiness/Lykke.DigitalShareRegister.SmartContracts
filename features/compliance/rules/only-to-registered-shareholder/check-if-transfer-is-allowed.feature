Feature: Check if transfer is allowed

    Scenario Outline: Checking if transfer is allowed
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        And shareholder register smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |
        And Alice included Bob into shareholder register
        And only to registered shareholder rule smart contract is deployed with the parameters:
            | Parameter            | Value                                          |
            | shareholder register | address of shareholder register smart contract |
        When I call only to registered shareholder rule smart contract if transfer of 1 LKK from me to <actor> is allowed
        
        And the call result is <result>

        Examples:
        | actor        | result |
        | Alice        | true   |
        | Bob          | true   |
        | Charlie      | false  |
        | Frank        | false  |
        | Grace        | false  |
        | Judy         | false  |
        | zero address | true   |
