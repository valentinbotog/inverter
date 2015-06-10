require 'test_helper'

class MetaTagsTest < Capybara::Rails::TestCase
  test 'meta tags render correctly' do
    visit '/meta_tags'

    assert page.body.include?('<title>Default Website Title</title>')
    assert page.body.include?('<meta property="og:type" content="website" />')
    assert page.body.include?('<meta property="og:title" content="Default Website Title" />')
    assert page.body.include?('<meta property="og:description" content="Default Website Description" />')
    assert page.body.include?('<meta property="og:image" content="https://slate-git-images.s3-us-west-1.amazonaws.com/slate.png" />')
  end
end
