# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reversi/version'

Gem::Specification.new do |spec|
  spec.name          = "reversi"
  spec.version       = Reversi::VERSION
  spec.authors       = ["seinosuke"]
  spec.summary       = %q{A Ruby Gem to play reversi game.}
  spec.homepage      = "https://github.com/seinosuke/reversi"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/reversi/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.7"

  spec.description   = <<-END
A Ruby Gem to play reversi game. You can enjoy a game on the command line
or easily make your original reversi game programs.
END
end
