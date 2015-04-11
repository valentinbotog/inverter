module Inverter
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # workaround this method so no need to call it if:
      #  - not GET request
      #  - not action request (assets or public files)
      Inverter.model_class.sync_with_templates!

      @app.call(env)
    end
  end
end




