# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redundant_column/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hooopo"]
  gem.email         = ["hoooopo@gmail.com"]
  gem.description   = %q{redundant column for activerecord}
  gem.summary       = %q{redundant column for activerecord}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "redundant_column"
  gem.require_paths = ["lib"]
  gem.version       = RedundantColumn::VERSION
end
