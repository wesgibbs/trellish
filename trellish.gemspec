# -*- encoding: utf-8 -*-
require File.expand_path('../lib/trellish/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wes Gibbs"]
  gem.email         = ["wesgibbs@gmail.com"]
  gem.description   = %q{Annotate Trello cards with git branch, add 'Merge to master' checkbox, remove yourself and move the card to the QA list}
  gem.summary       = %q{Finish a Trello card}
  gem.homepage      = "http://rubygems.org/gems/trellish"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "trellish"
  gem.require_paths = ["lib"]
  gem.version       = Trellish::VERSION

  gem.add_dependency 'ruby-trello-wgibbs', '>=0.4.4'
end
