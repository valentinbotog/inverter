# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'inverter/version'

Gem::Specification.new do |s|
  s.name        = 'inverter'
  s.version     = Inverter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Kravets', 'Nataliia Kumeiko']
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

  s.add_dependency("render_anywhere", ">= 0.0.10")
  s.add_dependency("meta-tags",       ">= 2.0")
  s.add_dependency("mongoid-history", ">= 0.4.7")
  s.add_dependency("mongoid-slug",    ">= 4.0.0")
  s.add_dependency("redcarpet",       ">= 3.2.3")

  # automated tests
  s.add_development_dependency 'rails', '~> 4.1.2'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'minitest-focus'
end




