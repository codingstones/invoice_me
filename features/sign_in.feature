Feature: Sign In User
  In order to enter to the platform
  As a provider
  I want to authenticate

  Scenario: the credentials are ok
    Given an existing user
    And with right user and password
    When trying to authenticate
    Then is authenticated

  Scenario: the credentials are wrong
    Given an existing user
    And with wrong user or password
    When trying to authenticate
    Then is not authenticated
