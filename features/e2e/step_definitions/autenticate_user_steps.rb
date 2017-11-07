Given(/^an existing user$/) do
  @login_page = PageObjects::LoginPage.new(self)
end

Given(/^with right user and password$/) do
  @user = "12345678Z"
  @password = "password"
end

When(/^trying to authenticate$/) do
  @after_authenticate_page = @login_page.authenticate(@user, @password)
end

Then(/^is authenticated$/) do
  expect(@after_authenticate_page.logged_in?).to be true
end

Given(/^with wrong user or password$/) do
  @user = ""
  @password = "password"
end

Then(/^is not authenticated$/) do
  expect(@after_authenticate_page.logged_out?).to be true
end

Given(/^an signed in user$/) do
  login_page = PageObjects::LoginPage.new(self)
  @after_authenticate_page = login_page.authenticate("12345678Z", "password")
end

When(/^signs out$/) do
  @after_authenticate_page.logout
end
