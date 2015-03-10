module Inverter
  module Configuration

    attr_accessor(
      :model_class,
      :template_folders,
      :excluded_templates
    )

    def configure
      yield self
    end

    def self.extended(base)
      base.set_default_configuration
    end

    def set_default_configuration
      self.excluded_templates = []
    end

  end
end
