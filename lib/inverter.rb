require "inverter/concerns/inverter"
require "inverter/object"
require "inverter/controller_helper"
require "inverter/configuration"
require "inverter/parser"
require "inverter/version"
require "inverter/engine"
require "inverter/template"

module Inverter
  extend Configuration
  extend Object
end

require "meta_tags"

ActionController::Base.send :include, Inverter::ControllerHelper
ActionView::Template.send   :include, Inverter::Template