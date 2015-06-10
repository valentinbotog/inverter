Inverter.configure do |config|
  config.model_class = Page
  config.template_folders   = %w( pages )
  config.excluded_templates = %w( pages/excluded )
  # do not look for template changes while development
  config.disable_middleware = false
end
