# Inverter

## Easy way to connect Rails templates content to CMS

Mark CMS-editable content using special formatted comments right in Rails templates. It automatically populated to models and is accessible via CMS of choice. When template is rendered editable content is pulled from databased automatically.

## Installation

Add to ```Gemfile```:

    gem "inverter", github: "slate-studio/inverter"

Setup initializer ```config/initializers/inverter.rb```:

  ```ruby
  Inverter.configure do |config|
    config.model_class = Page # model that stores template editable blocks
    config.template_folders = %w( pages ) # folders which templates are editable
  end
  ```

Configure model that stores template content, e.g. ```models/page.rb```:

  ```ruby
  class Page
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Inverter
  end
  ```

Setup admin page controller configuration ```controllers/admin/pages_controller.rb```, this keeps models in sync with template files changes:

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

Controller filter above tracks changes in editable templates on every ```index``` request. This helps to keep models up to date while app development. If new template added to folders it's linked automatically and removed if existing one deleted. Editable piece of content in the template is called name, each block should be named.

An example of editable template with three content blocks, e.g. ```pages/about.html.erb```:

  ```html
  <h1>About</h1>

  <!--[ subtitle ]-->
  <p>
    This is an example of the content block named subtitle. This content is editable via CMS, please go to website <%= link_to 'admin', admin_path %> and check how it can be changed.</p>
  <!--END-->

  <!--[ body ]-->
  <p>
    Blocks could have not only plain HTML but a Ruby template code as well. For example these links below are going to be rendered and saved as HTML links in the models. You can access <%= link_to 'welcome', page_path('welcome') %> &amp; <%= link_to 'about', page_path('about') %> pages.
  <!--END-->

  <!--[ footer ]-->
  <p>
    This is an example of the content block named footer. This content is editable via CMS, please go to website <%= link_to 'admin', admin_path %> and check how it can be changed.</p>
  <!--END-->
  ```


## Inverter family

- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add restful actions for mongoid models
- [Character](https://github.com/slate-studio/chr): A simple and lightweight javascript library for building data management web apps

## Credits

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Inverter is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.

## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Character is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).