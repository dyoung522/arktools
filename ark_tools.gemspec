# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ark_tool/version"

Gem::Specification.new do |spec|
  spec.name          = "ArkTools"
  spec.version       = ArkTools::VERSION
  spec.authors       = ["Donovan Young"]
  spec.email         = ["dyoung522@gmail.com"]

  spec.summary       = %q{Creates ARK configuration files}
  spec.description   = %Q{Uses various template files to create ARK configuration files\n} +
                       %Q{ - Game.ini\n} +
                       %Q{ - GameUserSettings.ini\n}
  spec.homepage      = "https://github.com/dyoung522/arkconfig"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "config", "~> 1.3"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "io-console", "~> 0.4"
  spec.add_dependency "inifile", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
