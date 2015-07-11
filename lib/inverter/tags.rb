module Inverter
  class Tags
    def self.update_html(html)
      tags = parse_tags(html)

      tags.each do |tag, partials|
        tag_name = partials[0]
        params   = partials[1]

        if helper_exists?(tag_name)
          helper_result = call_helper(tag_name, params)
          html.gsub!(tag, helper_result)
        end
      end

      return html
    end

    private

      def self.parse_tags(text)
        regex  = /\[[a-zA-Z0-9\-]{2,}#[a-zA-Z0-9\-,]{2,}\]/
        result = {}

        text.scan(regex).each do |tag|
          result[tag] = tag.gsub(/(\[|\])/, '').split('#')
        end

        return result
      end


      def self.call_helper(tag_name, params)
        name = helper_name(tag_name)
        ApplicationController.helpers.send(name, params)
      end


      def self.helper_exists?(tag_name)
        name = helper_name(tag_name)
        ApplicationController.helpers.respond_to? name
      end


      def self.helper_name(tag_name)
        name = tag_name.downcase.gsub('-', '_')
        return "inverter_#{ name }"
      end

  end

end
