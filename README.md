# Inverter

## Easy way to connect Rails templates content to CMS

Mark CMS-editable content using special formatted comments right in Rails templates. It automatically populated to models and is accessible via CMS of choice. When template is rendered editable content is pulled from databased automatically.

## Installation

Add to ```Gemfile```

  gem "inverter", github: "slate-studio/inverter"

Setup model configuration ```models/page.rb```:

  ```ruby
  class Page
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::SerializableId
    include Mongoid::Inverter
  end
  ```

Setup admin page controller configuration ```controllers/admin/pages_controller.rb```:

  ```ruby
  class Admin::PagesController < Admin::BaseController
    mongosteen

    before_filter :syncronize_templates, only: [ :index ]

    protected

      def syncronize_templates
        if Rails.env.development?
          resource_class.sync_objects_with_templates!
        end
      end
  end
  ```

Setup initializer ```config/initializers/inverter.rb```:

  ```ruby
  Inverter.configure do |config|
    config.model_class = Page
    config.template_folders = %w( pages )
  end
  ```

## Inverter family

- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add restful actions for mongoid models
- [Character](https://github.com/slate-studio/chr): A simple and lightweight javascript library for building data management web apps

## Credits

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Inverter is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.

## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Character is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).