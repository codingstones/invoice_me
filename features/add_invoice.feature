Feature: Add an invoice
  In order to get paid
  As a provider
  I want to add an invoice

  Background:
    Given a provider identified

  Scenario: with all the required information
    Given all invoice valid information
    When adds an invoice
    Then the invoice is added

  Scenario: without invoice number
    Given all invoice valid information
    But the invoice number is empty
    When adds an invoice
    Then the invoice is not added

  Scenario: without invoice date
    Given all invoice valid information
    But the invoice date is empty
    When adds an invoice
    Then the invoice is not added
