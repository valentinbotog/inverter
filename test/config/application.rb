# Initialize a dummy application that is required to test
# the gem that supplies some behavior to another rails application


#
# Rails
#

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Define the application and configuration
module RbConfig
  class Application < ::Rails::Application
    config.eager_load = false

    # config.active_support.deprecation = :stderr
    # config.autoload_paths += %W(#{config.root}/app/controllers/concerns)

    path_secrets_config = File.join(File.dirname(__FILE__), "secrets.yml")
    config.secret_key_base = YAML.load(File.open(path_secrets_config))[Rails.env]['secret_key_base']
  end
end

# Initialize the application
RbConfig::Application.initialize!


#
# Mongoid
#

require "mongoid"

path_to_mongoid_config = File.join(File.dirname(__FILE__), "mongoid.yml")
Mongoid.load!(path_to_mongoid_config)


#
# Kaminari
#

require "kaminari"
Kaminari::Hooks.init


#
# Inverter
#

require "inverter"

RbConfig::Application.routes.draw do
  mount_inverter_instance
end
