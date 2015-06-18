module TemplateHelper
  def mock_template(file_name, html)
    File.write(Rails.root.join('app/views', file_name), html)
  end

  def remove_templates(folder)
    FileUtils.rm_rf(Dir.glob(Rails.root.join('app/views', folder, '*')))
  end
end
