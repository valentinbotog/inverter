module Mongoid
  module Inverter
    extend ActiveSupport::Concern

    included do
      include Mongoid::Timestamps
      include Mongoid::Slug
      include Mongoid::History::Trackable
      include Ants::Meta
      include Ants::Versions

      # ATTRIBUTES
      field :_template_name
      field :_name,                       default: ''
      field :_blocks,      type: Hash,    default: {}
      field :_ignore_sync, type: Boolean, default: false

      # HISTORY
      track_history track_create: true
      # # telling Mongoid::History how you want to track changes
      # # dynamic fields will be tracked automatically (for MongoId 4.0+ you should include Mongoid::Attributes::Dynamic to your model)
      # track_history   :on => [:title, :body],       # track title and body fields only, default is :all
      #                 :modifier_field => :modifier, # adds "belongs_to :modifier" to track who made the change, default is :modifier
      #                 :modifier_field_inverse_of => :nil, # adds an ":inverse_of" option to the "belongs_to :modifier" relation, default is not set
      #                 :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
      #                 :track_create   =>  false,    # track document creation, default is false
      #                 :track_update   =>  true,     # track document updates, default is true
      #                 :track_destroy  =>  false     # track document destruction, default is false


      # SCOPES
      default_scope -> { asc(:created_at) }
      scope :available_for_sync, -> { where(_ignore_sync: false) }

      # INDEXES
      index({ _template_name: 1 })
      index({ _ignore_sync:   1 })

      # SLUG
      # used in cms for direct object access
      slug do |current_object|
        current_object._template_name.gsub('.html.erb', '').gsub('/', '-')
      end


      # returns title to be used in cms and identify page in list
      def _list_item_title
        self._name.empty? ? self._template_name : self._name
      end


      # populates seo values to cached meta_tags object which is
      # used by ActionController while template rendering
      def update_inverter_meta_tags
        ::Inverter.meta_tags[:og] ||= {}

        unless self.meta_title.empty?
          ::Inverter.meta_tags[:title]      = self.meta_title
          ::Inverter.meta_tags[:og][:title] = self.meta_title
        end

        unless self.meta_description.empty?
          ::Inverter.meta_tags[:description]      = self.meta_description
          ::Inverter.meta_tags[:og][:description] = self.meta_description
        end

        unless self.meta_keywords.empty?
          ::Inverter.meta_tags[:keywords] = self.meta_keywords
        end

        unless self.opengraph_image_url.empty?
          ::Inverter.meta_tags[:og][:image] = self.opengraph_image_url
        end
      end


      # updates blocks in html with objects _blocks hash values
      def update_html(html)
        html = ::Inverter::Renderer.render(html, self._blocks)
        return html
      end


      # returns datetime when template was updated
      def template_updated_at
        template_path = Rails.root.to_s + '/app/views/' + self._template_name
        File.mtime(template_path).getgm
      end


      # check if template file was changed after object was saved
      def template_changed?
        template_updated_at > updated_at.getgm
      end


      # read template blocks and save to objects _blocks hash
      def update_from_template!
        template_parser = ::Inverter::Parser.new(self._template_name)
        template_blocks = template_parser.blocks
        name            = template_parser.name

        # add new blocks
        keys_to_add = template_blocks.keys - self._blocks.keys
        keys_to_add.each do |key|
          self._blocks[key] = template_blocks[key]
        end

        # remove old blocks
        keys_to_remove = self._blocks.keys - template_blocks.keys
        keys_to_remove.each do |key|
          self._blocks.delete(key)
        end

        # keep same blocks order as in template
        ordered_blocks = {}
        template_blocks.keys.each { |k| ordered_blocks[k] = self._blocks[k] }
        self._blocks = ordered_blocks

        # update page name
        self._name = name

        # force update_at change event the conten not changed
        self.updated_at = Time.now

        save
      end


      # class methods


      # creat new page object from template
      def self.create_from_template(template_name)
        template_parser = ::Inverter::Parser.new(template_name)
        template_blocks = template_parser.blocks
        name            = template_parser.name
        create(_name: name, _template_name: template_name, _blocks: template_blocks)
      end


      # syncronize templates with existing page objects
      def self.sync_with_templates!
        template_names          = get_template_names
        created_objects         = self.available_for_sync
        existing_template_names = created_objects.map { |o| o._template_name }

        # add new objects
        if existing_template_names.size < template_names.size
          ap "Create Inverter objects for new templates: "
          template_names_to_create = template_names - existing_template_names
          template_names_to_create.each do |name|
            create_from_template(name)
            ap " - #{ name }"
          end
        end

        # delete object for removed templates
        if existing_template_names.size > template_names.size
          ap "Delete Inverter objects for missing templates: "
          template_names_to_remove = existing_template_names - template_names
          template_names_to_remove.each do |name|
            find_by(_template_name: name).destroy
            ap " - #{ name }"
          end
        end

        # update objects for changes in templates
        changed_objects = created_objects.select { |o| o.template_changed? }
        if changed_objects.size > 0
          ap "Update Inverter objects for changed templates: "
          changed_objects.each do |o|
            o.update_from_template!
            ap " - #{ o._template_name }"
          end
        end
      end


      # returns list of template names for gem configuration in
      # config/initializers/inverter.rb
      def self.get_template_names
        template_file_names = []

        ::Inverter.template_folders.each do |folder_name|
          path = Rails.root.join('app/views', "#{ folder_name }/**/*.html.erb")
          file_names = Dir[path]
          template_file_names.concat(file_names)
        end

        template_names = template_file_names.map do |file_name|
          file_name.gsub(Rails.root.to_s + '/app/views/', '')
        end

        # skip rails partials
        template_names.reject! { |n| n.split('/').last.start_with? '_' }

        # exclude names from excluded_templates configuration list
        excluded_template_names = ::Inverter.excluded_templates.map { |name| "#{ name }.html.erb" }
        template_names = template_names - excluded_template_names

        return template_names
      end
    end
  end
end




