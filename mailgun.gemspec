# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'mailgun'
  spec.version     = "1.0"
  spec.authors     = ['Menno Wildeboer']
  spec.email       = 'menno@prco.com'
  spec.summary     = 'Mailgun gem'
  spec.description = 'Interact with Mailgun in Ruby'
  spec.homepage    = 'http://github.com/prco/mailgun'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'mimemagic'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'ruby_gntp'
  spec.add_development_dependency 'bundler', '~> 1.6'
end
