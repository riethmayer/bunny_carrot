# -*- coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bunny_carrot/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bunny_carrot"
  s.version     = BunnyCarrot::VERSION
  s.authors     = ["Paired by Andrzej Śliwa + Vladimir Zhukov, bonusbox GmbH"]
  s.email       = ["andrzej.sliwa@i-tool.eu, voldyjeengle@gmail.com"]
  s.homepage    = "https://github.com/bonusboxme/bunny_carrot"
  s.summary     = "The carrot for bunny. A rabbitmq-consumer."
  s.description = <<-STR
BunnyCarrot is a worker implementation using the rabbitmq-client bunny.
Based on actor-models it allows concurrent and supervised consumer-strategies.
STR
  s.files       = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "concurrent-ruby", "~> 0.5.0"
  s.add_dependency "hamster", "~> 0.4.3"
  s.add_dependency "bunny", "~> 0.10.8"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
