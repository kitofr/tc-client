# encoding: utf-8

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require "version"

Gem::Specification.new do |s|
  s.name        = "tc-client"
  s.version     = TCClient::Version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kristoffer Roupe"]
  s.email       = ["kitofr@gmail.com"]
  s.homepage    = "http://github.com/kitofr/tc-client"
  s.add_dependency "rest-client", ">= 1.6.1"

  s.summary     = %q{A simple ruby based Team City build checker}
  s.description = %q{Sometimes you just need to know!}

  s.rubyforge_project = "tc-client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 1.8.7'
end

