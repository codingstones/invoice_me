Given(/^a provider identified$/) do
  page.reset!
  visit '/login'
  within("form") do
    fill_in 'user', with: "12345678Z"
    fill_in 'password', with: "password"
  end
  click_button 'Entrar'
end

Given(/^all invoice valid information$/) do
  @invoice_data = { date: "2023-05-11",
    lines: [{description: 'a expense', base: 100, vat: 21, retention: 15}],
    document_number: '17/2017'}
end

When(/^adds an invoice$/) do
  visit '/new'
  within("form") do
    fill_in 'document_number', with: @invoice_data[:document_number]
    fill_in 'date', with: @invoice_data[:date]
    fill_in 'description[]', with: @invoice_data[:lines].first[:description]
    fill_in 'base[]', with: @invoice_data[:lines].first[:base]
    fill_in 'vat[]', with: @invoice_data[:lines].first[:vat]
    fill_in 'retention[]', with: @invoice_data[:lines].first[:retention]
  end
  click_button 'Registrar factura'
end

Then(/^the invoice is added$/) do
  expect(page.first(:css, 'h1').text).to eq 'Facturas registradas'
end

Given(/^the invoice number is empty$/) do
  @invoice_data[:document_number] = ""
end

Then(/^the invoice is not added$/) do
  expect(page).to have_css("div.errors")
end

Given(/^the invoice date is empty$/) do
  @invoice_data[:date] = ""
end

When(/^get all provider invoices$/) do
  visit '/'
end

Then(/^invoices are retrieved$/) do
  expect(page).to have_css(".invoices-list li")
end
