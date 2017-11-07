Given(/^a provider identified$/) do
  @provider_id = "12345678Z"
end

Given(/^all invoice valid information$/) do
  @invoice_data = { date: Date.today,
    lines: [{description: 'a expense', base: 100, vat: 21, retention: 15}],
    document_number: '17/2017'}
end

When(/^adds an invoice$/) do
  add_invoice_action = InvoiceMe::Factory.new.add_invoice_action

  VCR.use_cassette("add_invoice") do
    begin
      @invoice = add_invoice_action.run(@provider_id, @invoice_data)
    rescue InvoiceMe::InvalidInvoiceError => @invalid_invoice_error
    end
  end
end

Then(/^the invoice is added$/) do
  expect(@invoice).not_to be_nil
  expect(@invoice.id).not_to be_nil
end

Given(/^the invoice number is empty$/) do
  @invoice_data.delete(:document_number)
end

Then(/^the invoice is not added$/) do
  expect(@invalid_invoice_error.class).to eq InvoiceMe::InvalidInvoiceError
end

Given(/^the invoice date is empty$/) do
  @invoice_data.delete(:date)
end

When(/^get all provider invoices$/) do
  get_invoices_by_provider_action = InvoiceMe::Factory.new.get_invoices_by_provider_action

  VCR.use_cassette("find_expenses") do
    @invoices_by_provider = get_invoices_by_provider_action.run("348489")
  end
end

Then(/^invoices are retrieved$/) do
  expect(@invoices_by_provider).not_to be_nil
end
