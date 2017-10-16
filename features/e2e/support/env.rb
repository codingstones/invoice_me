require 'capybara/cucumber'
require_relative '../../../app'

Capybara.app = Sinatra::Application
