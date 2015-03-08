require 'render_anywhere'

module Inverter
  class Parser
    include RenderAnywhere

    START_DELIMITER = "<!--["
    NAME_DELIMITER  = "]-->"
    END_DELIMITER   = "<!--END-->"

    def initialize(template_name)
      @template_name = template_name
    end

    # parses rendered template and returns hash with block
    # names and content to be editable
    def parse
      result  = {}
      content = render template: @template_name, layout: false

      s = content.index(START_DELIMITER)
      e = content.index(END_DELIMITER)

      while s && e
        s += START_DELIMITER.size
        block = content[s..e-1]

        key, value   = parse_block(block)
        result[key] = value

        e += END_DELIMITER.size
        content = content[e..-1]

        s = content.index(START_DELIMITER)
        e = content.index(END_DELIMITER)
      end

      return result
    end

    def parse_block(block)
      n = block.index(NAME_DELIMITER)
      key = block[0..n-1].strip

      n += NAME_DELIMITER.size
      value = block[n..-1]

      return key, value
    end

    # class methods

    # returns a hash with content blog start and end positions
    # to be replaced with updated content
    # e.g: { "header"=>[32, 178], "body"=>[206, 352] }
    def self.map_blocks_for(content)
      map   = {}
      delta = 0

      s = content.index(START_DELIMITER)
      e = content.index(END_DELIMITER)

      while s && e
        s += START_DELIMITER.size

        n   = content[s..e-1].index(NAME_DELIMITER)
        key = content[s..s+n-1].strip

        n += NAME_DELIMITER.size
        map[key] = [delta+s+n, delta+e-1]

        e += END_DELIMITER.size
        content = content[e..-1]
        delta  += e

        s = content.index(START_DELIMITER)
        e = content.index(END_DELIMITER)
      end

      return map
    end
  end
end




