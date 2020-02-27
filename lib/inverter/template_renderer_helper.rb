module Inverter
  module TemplateRendererHelper
    extend ActiveSupport::Concern

    included do
      alias_method :render, :inverter_object
    end


    def render_with_inverter_object(context, options)
      inverter_object = nil

      template_name = options[:template]
      prefixes      = options[:prefixes]

      template_candidates = template_name.presence ? [ template_name ] : []

      if prefixes
        template_candidates = prefixes.collect { |prefix| "#{ prefix }/#{ template_name }" }
      end

      template_candidates.each do |template_candidate|
        name = "#{ template_candidate }.html.erb"

        # set inverter object if it's not already set, return nil if already set
        inverter_object = Inverter.update_inverter_object(name)

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
