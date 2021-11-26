Feature: Manage shareholders

    Background:
        Given shares token smart contract is deployed with the parameters:
            | Parameter | Value        |
            | name      | Lykke Shares |
            | symbol    | LKK          |
            | issuer    | Alice        |
        Given shareholder register smart contract is deployed with the parameters:
            | Parameter    | Value                                  |
            | shares token | address of shares token smart contract |


    Scenario: Including shareholder into register
        When Alice includes Bob into shareholder register
        And I call shareholder register smart contract if Bob is a shareholder
        Then the transaction execution result is success
        And the call result is true

    Scenario: Excluding shareholder from register
        Given Alice included Bob into shareholder register
        When Alice excludes Bob from shareholder register
        And I call shareholder register smart contract if Bob is a shareholder
        Then the transaction execution result is success
        And the call result is false