require File.expand_path("../lib/hash_accessor", __FILE__)

Gem::Specification.new do |s|
  s.name = "hashAccessor"
  s.version = hashAccessor::VERSION
  s.author = ["Forrest"]
  s.email = ["development@forrestzeisler.com"]
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  
  
  s.description = 'This gem provides accessor methods to hash keys.'
  s.summary = "This gem provides extended functionality to serialized hashed in rails. It allows you to define accessor methods for variable that rest "+
              "inside a serialized hash. This is very useful if you have a large list of often changing DB variables on a model which don't get queried against."
  
  s.required_rubygems_version = ">= 1.3.6"
  s.platform = Gem::Platform::RUBY

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path  = "lib"
  
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
end