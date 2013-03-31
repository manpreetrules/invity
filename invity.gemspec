# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invity/version'

Gem::Specification.new do |gem|
  gem.name          = "invity"
  gem.version       = FbInvity::VERSION
  gem.authors       = ["Pavittar Gill"]
  gem.email         = ["pavittar_gill@yahoo.ca"]
  gem.description   = %q{Send message to facebook inbox through your rails app.}
  gem.summary       = %q{Send invitation through your rails app.}
  gem.homepage      = "https://github.com/pavittar/invity"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"

  gem.add_runtime_dependency('faraday'        , ["0.8.7"])
  gem.add_runtime_dependency('xmpp4r_facebook', ["0.1.1"])
end