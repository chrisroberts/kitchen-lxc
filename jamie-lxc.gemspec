Gem::Specification.new do |gem|
  gem.name          = "jamie-lxc"
  gem.version       = "0.0.1.alpha2"
  gem.authors       = ["Sean Porter"]
  gem.email         = ["portertech@gmail.com"]
  gem.description   = "LXC driver for Jamie"
  gem.summary       = "LXC driver for Jamie"
  gem.homepage      = "https://github.com/portertech/jamie-lxc"
  gem.license       = "MIT"
  gem.has_rdoc      = false

  gem.add_dependency("jamie")

  gem.add_development_dependency("rake")

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
