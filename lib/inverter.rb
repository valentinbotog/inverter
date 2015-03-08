require 'inverter/concerns/inverter'
require 'inverter/configuration'
require 'inverter/parser'

module Inverter
  extend Configuration

  require 'inverter/version'
  require 'inverter/engine'
end

module ActionView
  class Template
    alias_method :initialize_original, :initialize

    def initialize(source, identifier, handler, details)
      inverter_object = _inverter_object(identifier)
      if inverter_object
        source = inverter_object.update_template_source(source)
      end

      initialize_original(source, identifier, handler, details)
    end

    private

      def _inverter_object(identifier)
        template_name = identifier.gsub(Rails.root.to_s + '/app/views/', '')

        if template_name.start_with?(*Inverter.template_folders)
          return Inverter.model_class.where(template_name: template_name).first
        end

        return nil
      end
  end
end


