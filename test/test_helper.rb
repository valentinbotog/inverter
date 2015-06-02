ENV['RAILS_ENV'] ||= 'test'
$:.unshift File.dirname(__FILE__)
require "rails_app/config/environment"
require 'rails/test_help'
require 'helpers/template_helper'
require 'database_cleaner'

class ActiveSupport::TestCase
  include TemplateHelper

  def setup
    DatabaseCleaner.clean
    remove_templates('pages')
  end
end
