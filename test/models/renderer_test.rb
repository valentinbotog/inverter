require 'test_helper'

class RendererTest < ActiveSupport::TestCase
  test 'doesn\'t change html without blocks' do
    html = Inverter::Renderer.render('<div>Test</div>', {})

    assert_equal('<div>Test</div>', html)
  end

  test 'change html with blocks' do
    html = Inverter::Renderer.render('<div><!--[ Test Block ]-->Hero Text<!--END--></div>', {'Test Block' => 'Test Value'})

    assert_equal("<div><!--[ Test Block ]-->\nTest Value\n<!--END--></div>", html)
  end
end
