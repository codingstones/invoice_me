@ui_only
Feature: Sign Out
  In order to leave the platform
  As a provider
  I want to sing out

  Scenario: the user signs out
    Given an signed in user
    When signs out
    Then is not authenticated
