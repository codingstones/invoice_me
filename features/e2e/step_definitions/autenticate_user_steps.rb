Given(/^an existing user$/) do
  page.reset!
  visit '/login'
end

Given(/^with right user and password$/) do
  within("form") do
    fill_in 'user', with: "12345678Z"
    fill_in 'password', with: "password"
  end
end

When(/^trying to authenticate$/) do
  click_button 'Entrar'
end

Then(/^is authenticated$/) do
  expect(page.first(:css, 'h1').text).to eq 'Facturas registradas'
end

Given(/^with wrong user or password$/) do
  within("form") do
    fill_in 'user', with: ""
    fill_in 'password', with: "password"
  end
end

Then(/^is not authenticated$/) do
  expect(page.first(:css, 'h1').text).to eq 'Entra a registrar tus facturas'
end

Given(/^an signed in user$/) do
  page.reset!
  visit '/login'
  within("form") do
    fill_in 'user', with: "12345678Z"
    fill_in 'password', with: "password"
  end
  click_button 'Entrar'
end

When(/^signs out$/) do
  click_link 'Salir'
end
