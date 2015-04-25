# Inverter

*Easy way to connect Rails templates content to CMS*

Mark content that you want to change via CMS in Rails templates. It's automatically populated to models and is accessible via CMS. When Rails renders template it pulls editable content from databased automatically.


## Setup

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

  # disable Inverter middleware
  config.disabled_middleware = false
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

Setup admin page controller configuration ```controllers/admin/pages_controller.rb```:

```ruby
class Admin::PagesController < Admin::BaseController
  mongosteen
  json_config({ methods: [ :list_item_title, :version_options ])
end
```


### Meta Tags

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


### View Example

An example of editable template with five content blocks and page name (to identify page in CMS), e.g. ```pages/about.html.erb```:

```html
<!--// About //-->
<h1>About</h1>

<!--[ hero : inverter-image ]-->
  <%= image_tag('hero-1.png', alt: 'Welcome to Inverter') %>
<!--END-->

<!--[ subtitle ]-->
<p>
  Blocks could have not only plain HTML but a Ruby template code as well. For
  example these links below are going to be rendered and saved as HTML links in
  the page objects.</p>

<p>
  This content is editable via CMS, please go to website
  <%= link_to 'admin', admin_path %> and check how it can be changed.</p>
<!--END-->

<!--[ body : markdown ]-->
You can use markdown in your views as well. [redcarpet](https://github.com/vmg/redcarpet)
gem is used as markdown rendere.
<!--END-->

<!--[ footer ]-->
<p>
  This is an example of the content block named footer. This content is editable
  via CMS, please go to website <%= link_to 'admin', admin_path %> and check how
  it can be changed.</p>
<!--END-->

<!--[ footer_link : inverter-link ]-->
<p>
  <%= link_to 'Slate', 'http://www.slatestudio.com', target: '_blank' %></p>
<!--END-->
```


### Middleware

Inverter middleware helps to keep inverter objects up to date with template changes in development environment.

If new template added to tracked folders it's linked automatically and correspoding inverter object created. After tracked template deleted a tracking inverter object is removed as well.

It also watches changes in templates: adding new blocks and removing existing ones. When block is renamed inverter thinks that the new one added and previous removed so content for the previous is lost.


### Character Configuration

Inverter supports [chr](https://github.com/slate-studio/chr) out of the box. Include custom input in the cms configuration file ```admin.coffee```, and setup module configuration:

```coffeescript

#= require inverter

pagesConfig = ->
  itemTitleField: 'list_item_title'
  disableNewItems: true
  disableDelete:   true
  arrayStore: new RailsArrayStore({
    resource: 'page'
    path:     '/admin/pages'
  })
  formSchema:
    version:           { type: 'inverter-version', path: '/admin/pages' }
    _page_title:       { type: 'string', label: 'Title'                 }
    _page_description: { type: 'text',   label: 'Description'           }
    _page_keywords:    { type: 'text',   label: 'Keywords'              }
    _page_image_url:   { type: 'string', label: 'Image URL'             }
    _blocks:           { type: 'inverter'                               }
```

Inverer ```version``` input allows to select previous version of the page to edit.

Inverter input has an option ```defaultInputType``` that specifies what input type should be used as default, if nothing specified ```text``` is used. This might be set to WYSIWYG editor of your choice, e.g:

```coffeescript
blocks: { type: 'inverter', defaultInputType: 'redactor' }
```

You can also specify input type that you want to use for specific block like this: ```<!--[ Main Body : text ]-->``` — in this case ```Main Body``` would be a label and ```text``` is an input type that will be used to edit this block in CMS.

Include inverter styles for cms inputs into character styles configuration file ```admin.scss```

```scss
@import "inverter";
```


### Rake Tasks

To reset all inverter objects to template defaults run:

    rake inverter:reset

**You need to run this rake task manually after first production deploy.** Middleware synchronizes objects only for development mode.

To sync all inverter objects with template changes run:

    rake inverter:sync

**You might need to run this command on production after deploy if some templates blocks were changed.**


## Inverter Family:

- [Character](https://github.com/slate-studio/chr): Powerful responsive javascript CMS for apps
- [Mongosteen](https://github.com/slate-studio/mongosteen): An easy way to add RESTful actions for Mongoid models
- [Inverter](https://github.com/slate-studio/inverter): An easy way to connect Rails templates content to Character CMS
- [Loft](https://github.com/slate-studio/loft): Media assets manager for Character CMS


## License

Copyright © 2015 [Slate Studio, LLC](http://slatestudio.com). Inverter is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).


## About Slate Studio

[![Slate Studio](https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png)](http://slatestudio.com)

Inverter is maintained and funded by [Slate Studio, LLC](http://slatestudio.com). Tweet your questions or suggestions to [@slatestudio](https://twitter.com/slatestudio) and while you’re at it follow us too.




