module Mongoid
  module Inverter
    extend ActiveSupport::Concern

    included do
      # attributes
      field :template_name
      field :blocks, type: Hash, default: {}

      # indexes
      index({ template_name: 1 })

      # helpers
      def template_changed?
        template_path = Rails.root.to_s + '/app/views/' + template_name
        template_time_updated = File.mtime(template_path)
        template_time_updated > updated_at
      end

      def update_blocks_from_template!
        template_blocks = ::Inverter::Parser.new(template_name).parse

        # add new blocks
        keys_to_add = template_blocks.keys - blocks.keys
        keys_to_add.each do |key|
          blocks[key] = template_blocks[key]
        end

        # remove old blocks
        keys_to_remove = blocks.keys - template_blocks.keys
        keys_to_remove.each do |key|
          blocks.delete(key)
        end

        save
      end

      def update_template_source(source)
        map = ::Inverter::Parser.map_blocks_for(source)

        offset = 0

        map.each do |name, pos|
          block = "\n" + blocks[name] + "\n"
          source[offset+pos[0]..offset+pos[1]] = block

          block_size          = block.size
          template_block_size = pos[1] - pos[0]
          offset             += block_size - template_block_size - 1
        end

        return source
      end

      # class methods
      def self.create_from_template(template_name)
        template_blocks = ::Inverter::Parser.new(template_name).parse
        create(template_name: template_name, blocks: template_blocks)
      end

      def self.sync_objects_with_templates!
        template_file_names = []

        ::Inverter.template_folders.each do |folder_name|
          path = Rails.root.join('app/views', "#{ folder_name }/**/*.html.erb")
          file_names = Dir[path]
          template_file_names.concat(file_names)
        end

        template_names = template_file_names.map do |file_name|
          file_name.gsub(Rails.root.to_s + '/app/views/', '')
        end

        created_objects         = self.all
        existing_template_names = created_objects.map { |o| o.template_name }

        # add new objects
        if existing_template_names.size < template_names.size
          template_names_to_create = template_names - existing_template_names
          template_names_to_create.each { |name| create_from_template(name) }
        end

        # delete object for removed templates
        if existing_template_names.size > template_names.size
          template_names_to_remove = existing_template_names - template_names
          template_names_to_remove.each { |name| find_by(template_name: name).delete }
        end

        # update objects for changes in templates
        created_objects.each do |o|
          if o.template_changed?
            o.update_blocks_from_template!
          end
        end
      end
    end
  end
end




