require 'test_helper'

class SyncTest < ActiveSupport::TestCase
  test 'check initial synchronization of templates with models' do
    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
      <!--[ footer ]-->
        <p>This is an example of the content block named footer.</p>
      <!--END-->
    )

    mock_template 'pages/excluded.html.erb', %(
      <!--// Excluded //-->
      <h1>Excluded</h1>

      <!--[ excluded block ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
    )

    Inverter.model_class.sync_with_templates!

    assert_equal(1, Page.count)

    assert_equal(2, Page.first["_blocks"].size)
    assert_equal("<p>This is an example of subtitle block</p>", Page.first["_blocks"]["subtitle"].strip)
    assert_equal("<p>This is an example of the content block named footer.</p>", Page.first["_blocks"]["footer"].strip)
  end

  test 'check synchronization of templates with models on block removal' do
    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
      <!--[ footer ]-->
        <p>This is an example of the content block named footer.</p>
      <!--END-->
    )

    Inverter.model_class.sync_with_templates!

    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
    )
    Page.first.update_attributes(updated_at: DateTime.yesterday)

    Inverter.model_class.sync_with_templates!

    assert_equal(1, Page.count)
    assert_equal(1, Page.first["_blocks"].size)
    assert_equal("<p>This is an example of subtitle block</p>", Page.first["_blocks"]["subtitle"].strip)
  end

  test 'check synchronization of templates with models on block creation' do
    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
    )

    Inverter.model_class.sync_with_templates!

    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
      <!--[ footer ]-->
        <p>This is an example of the content block named footer.</p>
      <!--END-->
    )

    Page.first.update_attributes(updated_at: DateTime.yesterday)

    Inverter.model_class.sync_with_templates!

    assert_equal(1, Page.count)

    assert_equal(2, Page.first["_blocks"].size)
    assert_equal("<p>This is an example of subtitle block</p>", Page.first["_blocks"]["subtitle"].strip)
    assert_equal("<p>This is an example of the content block named footer.</p>", Page.first["_blocks"]["footer"].strip)
  end

  test 'check synchronization on template removing' do
    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
    )

    Inverter.model_class.sync_with_templates!

    assert_equal(1, Page.count)

    remove_templates('pages')

    Inverter.model_class.sync_with_templates!

    assert_equal(0, Page.count)
  end

  test 'check synchronization of templates from different folders' do
    mock_template 'pages/about.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
    )

    mock_template 'about/index.html.erb', %(
      <!--// About //-->
      <h1>About</h1>
      <!--[ subtitle ]-->
        <p>This is an example of subtitle block</p>
      <!--END-->
    )

    Inverter.model_class.sync_with_templates!

    assert_equal(2, Page.count)
  end
end
