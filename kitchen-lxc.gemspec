Gem::Specification.new do |gem|
  gem.name          = "kitchen-lxc"
  gem.version       = "0.1.0"
  gem.authors       = ["Sean Porter", "Chris Roberts"]
  gem.email         = ["portertech@gmail.com", "code@chrisroberts.org"]
  gem.description   = "LXC driver for Test Kitchen"
  gem.summary       = "LXC driver for Test Kitchen"
  gem.homepage      = "https://github.com/chrisroberts/kitchen-lxc"
  gem.license       = "MIT"
  gem.has_rdoc      = false

  gem.add_dependency("test-kitchen", '~> 1.2', '>= 1.2.1')
  gem.add_dependency("elecksee", '~> 1.0', '>= 1.0.22')

  gem.add_development_dependency("rake")

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
