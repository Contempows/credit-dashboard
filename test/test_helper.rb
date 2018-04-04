ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include ActionDispatch::TestProcess::FixtureFile
  include Minitest::RSpecMocks
end

module FactoryGirl
  include ActionDispatch::TestProcess::FixtureFile
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

