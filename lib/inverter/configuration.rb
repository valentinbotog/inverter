module Inverter
  module Configuration

    attr_accessor(
      :model_class,
      :template_folders
    )

    def configure
      yield self
    end
  end
end
