Feature: Get Invoices By provider
  In order to known my historical
  As a provider
  I want to get all my sent invoices

  Scenario: get all the invoices by provider
    Given a provider identified
    When get all provider invoices
    Then invoices are retrieved
