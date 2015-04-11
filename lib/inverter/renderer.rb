module Inverter
  class Renderer

    def self.markdown_input_type?(name)
      name_and_type = name.split(':')

      if name_and_type.size > 1
        return name_and_type[1].strip == 'markdown'
      end

      return false
    end

    def self.render(html, blocks)
      # markdown configuration
      # https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

      offset = 0
      map = ::Inverter::Parser.map_blocks_for(html)

      map.each do |name, pos|

        block = blocks[name]

        if markdown_input_type?(name)
          block = markdown.render(block)
        end

        block = "\n#{ block }\n"

        html[offset+pos[0]..offset+pos[1]] = block

        block_size          = block.size
        template_block_size = pos[1] - pos[0]
        offset             += block_size - template_block_size - 1

      end

      return html
    end

  end
end