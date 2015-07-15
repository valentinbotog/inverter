require "mongoid_slug"
require "mongoid-history"
require "history_tracker"
require "redcarpet"

require "inverter/concerns/inverter"
require "inverter/object"
require "inverter/tags"
require "inverter/middleware"
require "inverter/controller_helper"
require "inverter/configuration"
require "inverter/parser"
require "inverter/renderer"
require "inverter/version"
require "inverter/template_renderer_helper"
require "inverter/engine"

module Inverter
  extend Configuration
  extend Object
end

require "meta_tags"
require "ants"

ActionController::Base.send :include, Inverter::ControllerHelper
ActionView::TemplateRenderer.send :include, Inverter::TemplateRendererHelper