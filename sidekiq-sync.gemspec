
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/sidekiq/sync/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-sync"
  spec.version       = Sidekiq::Sync::VERSION
  spec.authors       = ["Matti Paksula"]
  spec.email         = ["matti.paksula@iki.fi"]

  spec.summary       = %q{perform_sync for Sidekiq}
  spec.description   = %q{Adds perform_sync next to perform_async}
  spec.homepage      = "https://github.com/matti/sidekiq-sync"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq", ">= 5", "< 7"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard", "2.14.2", "~> 2.14"
  spec.add_development_dependency "guard-sidekiq", "0.1.0", "~> 0.1"
  spec.add_development_dependency "guard-rspec", "4.7.3", "~> 4.7"
  spec.add_development_dependency "kommando", "0.1.2", "~> 0.1"
end
