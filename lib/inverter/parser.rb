require 'render_anywhere'

module Inverter
  class Parser
    include RenderAnywhere

    NAME_START_DELIMITER = "<!--//"
    NAME_END_DELIMITER   = "//-->"

    BLOCK_START_DELIMITER = "<!--["
    BLOCK_NAME_DELIMITER  = "]-->"
    BLOCK_END_DELIMITER   = "<!--END-->"

    def initialize(template_name)
      @template_name = template_name
    end

    # parse name from template
    def parse_name
      name    = ''
      content = file_content

      s = content.index(NAME_START_DELIMITER)
      e = content.index(NAME_END_DELIMITER)

      unless s.nil?
        s += NAME_START_DELIMITER.size
        name = content[s..e-1].strip
      end

      return name
    end
    alias_method :name, :parse_name

    # parses rendered template and returns hash with block
    # names and content to be editable
    def parse
      result  = {}
      content = file_content

      s = content.index(BLOCK_START_DELIMITER)
      e = content.index(BLOCK_END_DELIMITER)

      while s && e
        s += BLOCK_START_DELIMITER.size
        block = content[s..e-1]

        key, value  = parse_block(block)
        result[key] = value

        e += BLOCK_END_DELIMITER.size
        content = content[e..-1]

        s = content.index(BLOCK_START_DELIMITER)
        e = content.index(BLOCK_END_DELIMITER)
      end

      return result
    end
    alias_method :blocks, :parse

    def parse_block(block)
      n = block.index(BLOCK_NAME_DELIMITER)
      key = block[0..n-1].strip

      n += BLOCK_NAME_DELIMITER.size
      value = block[n..-1]

      begin
        html = render inline: value, layout: false
      rescue
        html = "Template block wasn't rendered cause of a template syntax error."
      end

      return key, html
    end

    # class methods

    # returns a hash with content blocks name and [start, end] positions
    # to be replaced with updated content
    # e.g: { "header"=>[32, 178], "body"=>[206, 352] }
    def self.map_blocks_for(content)
      map   = {}
      delta = 0

      s = content.index(BLOCK_START_DELIMITER)
      e = content.index(BLOCK_END_DELIMITER)

      while s && e
        s += BLOCK_START_DELIMITER.size

        n   = content[s..e-1].index(BLOCK_NAME_DELIMITER)
        key = content[s..s+n-1].strip

        n += BLOCK_NAME_DELIMITER.size
        map[key] = [delta+s+n, delta+e-1]

        e += BLOCK_END_DELIMITER.size
        content = content[e..-1]
        delta  += e

        s = content.index(BLOCK_START_DELIMITER)
        e = content.index(BLOCK_END_DELIMITER)
      end

      return map
    end

    private

    def file_content
      @file_content ||= File.open(Rails.root.join("app/views", @template_name), "rb").read
    end
  end
end




