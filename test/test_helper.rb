ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails/capybara"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end
  # Add more helper methods to be used by all tests here...
end
