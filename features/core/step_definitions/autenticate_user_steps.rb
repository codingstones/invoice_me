Given(/^an existing user$/) do
end

Given(/^with right user and password$/) do
  @username = "12345678Z"
  @password = "password"
end

When(/^trying to authenticate$/) do
  authenticate_a_user_action = InvoiceMe::Factory.new.authenticate_a_user_action

  @found_user = authenticate_a_user_action.run(@username, @password)
end

Then(/^is authenticated$/) do
  expect(@found_user).not_to be_nil
end

Given(/^with wrong user or password$/) do
  @username = ""
  @password = "password"
end

Then(/^is not authenticated$/) do
  expect(@found_user).to be_nil
end
