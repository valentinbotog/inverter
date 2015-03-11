module Inverter
  module Template
    extend ActiveSupport::Concern

    included do
      alias_method  :initialize_original, :initialize

      def initialize(source, identifier, handler, details)
        template_name   = identifier.gsub(Rails.root.to_s + '/app/views/', '')
        inverter_object = Inverter.update_inverter_object(template_name)

        if inverter_object
          inverter_object.update_inverter_meta_tags()
        end

        initialize_original(source, identifier, handler, details)
      end
    end
  end
end




