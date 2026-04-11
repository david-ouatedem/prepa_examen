if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "/test/"
    add_filter "/config/"
    add_filter "/db/"
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Disable parallelism when measuring coverage (parallel processes don't merge results)
    parallelize(workers: ENV["COVERAGE"] ? 1 : :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    setup { I18n.locale = :en }
    teardown { I18n.locale = I18n.default_locale }
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
