require_relative "../page_objects/pages"
Given(/^a provider identified$/) do
  login_page = PageObjects::LoginPage.new(self)
  login_page.authenticate("12345678Z", "password")
end

Given(/^all invoice valid information$/) do
  @invoice_data = { date: "2023-05-11",
    lines: [{description: 'a expense', base: 100, vat: 21, retention: 15}],
    document_number: '17/2017'}
end

When(/^adds an invoice$/) do
  @register_invoice_page = PageObjects::RegisterInvoicePage.new(self)
  @register_invoice_page.register(@invoice_data)
end

Then(/^the invoice is added$/) do
  expect(@register_invoice_page.errors?).to be false
end

Given(/^the invoice number is empty$/) do
  @invoice_data[:document_number] = ""
end

Then(/^the invoice is not added$/) do
  expect(@register_invoice_page.errors?).to be true
end

Given(/^the invoice date is empty$/) do
  @invoice_data[:date] = ""
end

When(/^get all provider invoices$/) do
  @provider_invoices_page = PageObjects::ProviderInvoicesPage.new(self)
end

Then(/^invoices are retrieved$/) do
  expect(@provider_invoices_page.has_invoices?).to be true
end
