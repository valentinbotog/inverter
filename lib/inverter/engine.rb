module Inverter
  class Engine < Rails::Engine
    # auto wire
  end

  class Railtie < Rails::Railtie
    if Rails.env.development?
      initializer "inverter.configure_rails_initialization" do
        Rails.application.middleware.use Inverter::Middleware
      end
    end
  end
end




