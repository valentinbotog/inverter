ENV['RAILS_ENV'] ||= "test"

require 'config/application'
require 'rails/test_help'

require "database_cleaner"
DatabaseCleaner.strategy = :truncation

# There is no support of fixtures in Mongoid
require "factory_girl"
FactoryGirl.find_definitions

# Allows you to focus on a few tests with ease without having to use
# command-line arguments
require 'minitest/focus'

# Color output
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
# Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class ActiveSupport::TestCase
  # ...

  #
  # Helper methods to be used by all tests
  #

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  def reset_instance_variables(class_obj)
    class_obj.instance_variables.each do |var|
      class_obj.instance_variable_set var, nil
    end
  end
end
