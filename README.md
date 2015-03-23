# Inverter

## Easy way to connect Rails templates content to CMS

Mark right in Rails temlpates content that you want to change via CMS. It's automatically populated to models and is accessible via CMS. While Rails rendering template it's pulling editable content from databased automatically.

## Installation

Add to ```Gemfile```:

    gem "inverter", github: "slate-studio/inverter"

Setup initializer ```config/initializers/inverter.rb```:

  ```ruby
  Inverter.configure do |config|
    # model that stores template editable blocks
    config.model_class = Page

    # folders which templates are editable
    config.template_folders = %w( pages )

    # templates from template_folders the are not editable
    config.excluded_template_names = %w( pages/home )
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
    json_config({ methods: [ :list_item_title ])

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

An example of editable template with three content blocks and page name (to identify page in CMS), e.g. ```pages/about.html.erb```:

  ```html
  <!--// About //-->
  <h1>About</h1>

  <!--[ subtitle ]-->
  <p>
    This is an example of the content block named subtitle. This content is editable
    via CMS, please go to website <%= link_to 'admin', admin_path %> and check how
    it can be changed.</p>
  <!--END-->

  <!--[ body ]-->
  <p>
    Blocks could have not only plain HTML but a Ruby template code as well. For
    example these links below are going to be rendered and saved as HTML links in
    the models. You can access <%= link_to 'welcome', page_path('welcome') %> &amp;
    <%= link_to 'about', page_path('about') %> pages.</p>
  <!--END-->

  <!--[ footer ]-->
  <p>
    This is an example of the content block named footer. This content is editable
    via CMS, please go to website <%= link_to 'admin', admin_path %> and check how
    it can be changed.</p>
  <!--END-->
  ```

### Character Setup

Inverter supports [chr](https://github.com/slate-studio/chr) out of the box. Include custom input in the cms configuration file ```admin.coffee```, and setup module configuration:

  ```coffeescript

  #= require inverter

  pagesConfig = ->
    itemTitleField: 'list_item_title'
    disableNewItems: true
    disableDelete:   true
    arrayStore: new MongosteenArrayStore({
      resource: 'page'
      path:     '/admin/pages'
    })
    formSchema:
      _page_title:       { type: 'string', label: 'Title'       }
      _page_description: { type: 'text',   label: 'Description' }
      _page_keywords:    { type: 'text',   label: 'Keywords' }
      _page_image_url:   { type: 'string', label: 'Image URL'   }
      blocks: { type: 'inverter' }
  ```

Inverter input has an option ```defaultInputType``` which specifies what input type should be used as default, if nothing specified ```text``` is used. This might be set to WYSIWYG editor of your choice, e.g:

  ```coffeescript
  blocks: { type: 'inverter', defaultInputType: 'redactor' }
  ```

You can also specify input type that you want to use for specific block like this: ```<!--[ Main Body : text ]-->``` — in this case ```Main Body``` would be a label and ```text``` is an input type that will be used to edit this block in CMS.

### Meta Tags Support

```Mongoid::Inverter``` concern includes page meta tags fields. Check out [meta-tags](https://github.com/kpumuk/meta-tags) gem documentation for usage details, it helps to make pages SEO friendly.

To enable meta-tags support include following helper in application layout:

  ```erb
  <%= display_meta_tags title:       'Default Website Title',
                        description: 'Default Website Description',
                        open_graph: { type:        'website',
                                      title:       'Default Website Title',
                                      description: 'Default Website Description',
                                      image:       'https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png' } %>
  ```

To override default behavior add custom fields and write own ```update_inverter_meta_tags``` implementation.

## Inverter family

- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add restful actions for mongoid models
- [Character](https://github.com/slate-studio/chr): A simple and lightweight javascript library for building data management web apps

## Credits

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Inverter is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.

## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Character is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).