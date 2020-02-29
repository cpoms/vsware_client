
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vsware/version"

Gem::Specification.new do |spec|
  spec.name          = "vsware"
  spec.version       = Vsware::VERSION
  spec.authors       = ["Andrei Diaconu"]
  spec.email         = ["andrei.diaconu@cpoms.co.uk"]

  spec.summary       = %q{Ruby client for VSware}
  spec.description   = %q{Query data from VSware}
  spec.homepage      = "https://github.com/cpoms/vsware_client"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency "excon", ">= 0.45"
end
