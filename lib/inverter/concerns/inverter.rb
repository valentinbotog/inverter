module Mongoid
  module Inverter
    extend ActiveSupport::Concern

    included do
      # attributes
      field :_page_title,        default: ''
      field :_page_description,  default: ''
      field :_page_image_url,    default: ''

      field :_template_name
      field :_blocks, type: Hash, default: {}

      # indexes
      index({ _template_name: 1 })

      # helpers
      def update_inverter_meta_tags
        ::Inverter.meta_tags[:og] ||= {}

        unless self._page_title.empty?
          ::Inverter.meta_tags[:title]      = self._page_title
          ::Inverter.meta_tags[:og][:title] = self._page_title
        end

        unless self._page_description.empty?
          ::Inverter.meta_tags[:description]      = self._page_description
          ::Inverter.meta_tags[:og][:description] = self._page_description
        end

        unless self._page_image_url.empty?
          ::Inverter.meta_tags[:og][:image] = self._page_image_url
        end
      end

      def update_html(html)
        map = ::Inverter::Parser.map_blocks_for(html)

        offset = 0

        map.each do |name, pos|
          block = "\n" + self._blocks[name] + "\n"
          html[offset+pos[0]..offset+pos[1]] = block

          block_size          = block.size
          template_block_size = pos[1] - pos[0]
          offset             += block_size - template_block_size - 1
        end

        return html
      end

      def template_changed?
        template_path = Rails.root.to_s + '/app/views/' + self._template_name
        template_time_updated = File.mtime(template_path)
        template_time_updated > updated_at
      end

      def update_blocks_from_template!
        template_blocks = ::Inverter::Parser.new(self._template_name).parse

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

        save
      end

      # class methods
      def self.create_from_template(template_name)
        template_blocks = ::Inverter::Parser.new(template_name).parse
        create(_template_name: template_name, _blocks: template_blocks)
      end

      def self.sync_with_templates!
        template_names          = get_template_names
        created_objects         = self.all
        existing_template_names = created_objects.map { |o| o._template_name }

        # add new objects
        if existing_template_names.size < template_names.size
          template_names_to_create = template_names - existing_template_names
          template_names_to_create.each { |name| create_from_template(name) }
        end

        # delete object for removed templates
        if existing_template_names.size > template_names.size
          template_names_to_remove = existing_template_names - template_names
          template_names_to_remove.each { |name| find_by(_template_name: name).delete }
        end

        # update objects for changes in templates
        created_objects.each do |o|
          if o.template_changed?
            o.update_blocks_from_template!
          end
        end
      end

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




