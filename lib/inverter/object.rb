module Inverter
  module Object
    attr_accessor(
      :object,
      :meta_tags
    )

    def update_inverter_object(template_name)
      # proceed if inverter object is not set
      if Inverter.object.nil?
        # template is in inverter template folders
        if template_name.start_with?(*Inverter.template_folders)
          # template is not excluded via configuration
          template = template_name.gsub('.html.erb', '')
          if not Inverter.excluded_templates.include?(template)

            self.object = Inverter.model_class.where(_template_name: template_name).first
            return self.object

          end
        end
      end

      return nil
    end

    def reset_object
      self.object = nil
    end

    def set_meta_tags(meta_tags_collection)
      self.meta_tags = meta_tags_collection
    end
  end
end




