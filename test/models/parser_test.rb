require 'test_helper'

class ParserTest < ActiveSupport::TestCase
  test 'returns empty hash for template without blocks' do
    parser = Inverter::Parser.new 'test'

    def parser.file_content
      'Test file content without blocks'
    end

    assert_equal({}, parser.parse)
  end

  test 'parses templates with blocks' do
    parser = Inverter::Parser.new 'test'

    def parser.file_content
      '<div>
        <!--[ Hero / Text ]-->
          Hero Text
        <!--END-->
        <!--[ Hero / CTA : link ]-->
          Hero CTA link
        <!--END-->
      </div>'
    end

    assert_equal('Hero Text', parser.parse['Hero / Text'].strip)
    assert_equal('Hero CTA link', parser.parse['Hero / CTA : link'].strip)
  end
end
