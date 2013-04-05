# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boleto_br/version'

Gem::Specification.new do |gem|
  gem.name          = "boleto_br"
  gem.version       = BoletoBr::VERSION
  gem.authors       = ["Welington Sampaio", "Douglas Abreu", "Fabricio Monte"]
  gem.email         = ["welington.sampaio@zaez.net", "douglas.abreu@zaez.net", "fabricio.monte@zaez.net"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/welingtonsampaio/boleto_br"

  gem.add_development_dependency "rspec", ">= 2.13.0"
  gem.add_development_dependency "autotest-standalone"
  gem.add_development_dependency "test_notifier"
  gem.add_dependency "railties",       ">= 3.1"
  gem.add_dependency "sprockets",      ">  2.1"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
