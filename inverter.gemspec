# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'inverter/version'

Gem::Specification.new do |s|
  s.name        = 'inverter'
  s.version     = Inverter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Kravets']
  s.email       = 'alex@slatestudio.com'
  s.license     = 'MIT'
  s.homepage    = 'http://slatestudio.com'
  s.summary     = 'An easy way to connect Rails templates content to CMS.'
  s.description = <<-DESC
Easy way to connect Rails templates content to CMS. HTML content is marked using
special formatted comments. Then it automatically populated to models and is accessible
via CMS of choice. When template is rendered content stored in models content is
pulled from databased automatically.
  DESC

  s.rubyforge_project = 'inverter'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency('render_anywhere', '>= 0.0.10')
end



