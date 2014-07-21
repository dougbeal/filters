# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-filters/version'

Gem::Specification.new do |spec|
  spec.name          = "octopress-filters"
  spec.version       = Octopress::Tags::Filters::VERSION
  spec.authors       = ["Brandon Mathis"]
  spec.email         = ["brandon@imathis.com"]
  spec.summary       = %q{Return tag renders a variable with some nice features}
  spec.description   = %q{Return tag renders a variable with some nice features}
  spec.homepage      = "https://github.com/octopress/filters"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jekyll"
  spec.add_runtime_dependency "rubypants-unicode"
  spec.add_runtime_dependency "titlecase"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "clash"
  spec.add_development_dependency "octopress-filter-tag", "~> 1.0"
end
