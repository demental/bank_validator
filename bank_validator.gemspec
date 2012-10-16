# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bank_validator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["arnaud sellenet"]
  gem.email         = ["arnodmental@gmail.com"]
  gem.description   = %q{ActiveModel Bank data validation}
  gem.summary       = %q{Custom ActiveModel validator for BIC and IBAN}
  gem.homepage      = "https://github.com/demental/bank_validator"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bank_validator"
  gem.require_paths = ["lib"]
  gem.version       = BankValidator::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_runtime_dependency 'activemodel'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
