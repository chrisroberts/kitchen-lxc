Gem::Specification.new do |gem|
  gem.name          = "kitchen-lxc"
  gem.version       = "0.0.1.beta2"
  gem.authors       = ["Sean Porter"]
  gem.email         = ["portertech@gmail.com"]
  gem.description   = "LXC driver for Test Kitchen"
  gem.summary       = "LXC driver for Test Kitchen"
  gem.homepage      = "https://github.com/portertech/kitchen-lxc"
  gem.license       = "MIT"
  gem.has_rdoc      = false

  gem.add_dependency("test-kitchen", ">= 1.0.0.beta.4")
  gem.add_dependency("elecksee", "1.0.14")

  gem.add_development_dependency("rake")

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
