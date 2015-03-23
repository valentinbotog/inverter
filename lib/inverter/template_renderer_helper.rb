module Inverter
  module TemplateRendererHelper
    extend ActiveSupport::Concern

    included do
      alias_method_chain :render, :inverter_object
    end

    def render_with_inverter_object(context, options)
      template_name = options[:template]
      prefixes      = options[:prefixes]

      if prefixes
        template_prefix = prefixes[0]
        template_name   = "#{ template_prefix }/#{ template_name }"
      end

      if template_name
        template_name = "#{ template_name }.html.erb"

        # set inverter object if it's not already set, return nil if already set
        inverter_object = Inverter.update_inverter_object(template_name)

        if inverter_object
          inverter_object.update_inverter_meta_tags()
        end
      end

      # original render
      render_without_inverter_object(context, options)
    end
    protected :render_with_inverter_object

  end
end




